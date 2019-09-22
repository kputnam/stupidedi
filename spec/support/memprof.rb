# Based on https://github.com/SamSaffron/memory_profiler
require "objspace"
require "pathname"

class MemProf
  def initialize(options)
    @trace  = options[:trace]
    @ignore = options[:ignore]
    @allow  = options[:allow]
    @retain = true # options[:retain]
    @out    = options[:out]
  end

  def run(&block)
    start

    begin
      yield
    rescue Exception
      ObjectSpace.trace_object_allocations_stop
      GC.enable if @retain
      raise
    else
      stop
    end
  end

  private

  def start
    if @retain
      GC.start
      GC.start
      GC.start
      GC.disable
    end

    @generation = GC.count
    ObjectSpace.trace_object_allocations_start
  end

  def stop
    log "OS.trace_object_allocs_stop"
    ObjectSpace.trace_object_allocations_stop

    allocated = allocations
    retained  = Hash.new

    if @retain
      GC.enable
      GC.start
      GC.start
      GC.start

      log "retained = ..."
      ObjectSpace.each_object do |o|
        next if ObjectSpace.allocation_generation(o) != @generation
        match = allocations[o.__id__]
        retained[o.__id__] = match if match
      end if false
      log "retained = ... done"
    end

    log "OS.trace_object_allocs_clear"
    ObjectSpace.trace_object_allocations_clear

    log "Results.new..."
    Results.new(allocated.values, retained.values, out: @out)
  end

  def allocations
    results = Hash.new.compare_by_identity
    klass   = Kernel.instance_method(:class)
    pwd     = Dir.pwd << "/"

    log "OS.each_object { ... }"
    ObjectSpace.each_object do |o|
      next if ObjectSpace.allocation_generation(o) != @generation

      file = ObjectSpace.allocation_sourcefile(o).to_s
      next if @ignore and @ignore.match?(file)
      next if @allow  and not @allow.match?(file)
      file.gsub!(pwd, "")

      klass_ = klass.bind(o).call
      next if @trace and not @trace.match?(klass_)

      line   = ObjectSpace.allocation_sourceline(o)
      method = ObjectSpace.allocation_method_id(o)
      bytes  = ObjectSpace.memsize_of(o)

      results[o.__id__] = Stat.new(klass_, file, "%s:%s" % [file, line], method, bytes)
    end

    log "OS.each_object { ... } done"
    results
  end
end

MemProf::Stat = Struct.new(:klass, :file, :location, :method, :bytes)

class MemProf::Results
  def initialize(allocated, retained, options)
    @allocated = allocated
    @retained  = retained
    @out       = options[:out]
  end

  def allocations_by_class(xs = @allocated)
    log "allocations_by_class([#{xs.length}])"
    xs.group_by(&:klass).map do |key, stats|
      {group: key,
       stats: stats,
       bytes: stats.sum(&:bytes),
       count: stats.length}
    end.tap { log "allocations_by_class done" }
  end

  def allocations_by_method(xs = @allocated)
    log "allocations_by_method([#{xs.length}])"
    xs.group_by(&:method).map do |key, stats|
      {group: key,
       stats: stats,
       bytes: stats.sum(&:bytes),
       count: stats.length}
    end.tap { log "allocations_by_method done" }
  end

  def allocations_by_location(xs = @allocated)
    log "allocations_by_location([#{xs.length}])"
    xs.group_by(&:location).map do |key, stats|
      {group: key,
       stats: stats,
       bytes: stats.sum(&:bytes),
       count: stats.length}
    end.tap { log "allocations_by_location done" }
  end

  def print(limit: 50, io: $stdout)
    io = File.open(io, "w+") if io.is_a?(String)
    io.sync = true rescue nil

    io.puts "Total allocated: %s (%d objects)" % [
      human(@allocated.sum(&:bytes)), @allocated.size]

    io.puts "\n\nObjects most allocated\n#{"="*64}"
    allocations_by_class.sort_by{|x|-x[:count]}.tap{log "sorted"}.take(limit).each do |x|
      io.puts "%10s  %s" % [x[:count], x[:group]]
      allocations_by_location(x[:stats]).sort_by{|x|-x[:count]}.tap{log "sorted"}.take(5).each do |y|
        io.puts "         : %10s  %s" % [y[:count], y[:group]]
      end
      io.puts
    end

    # io.puts "\n\nMethods with most allocations\n#{"="*64}"
    # allocations_by_method.sort_by{|x| -x[:count] }.take(limit).each do |x|
    #   io.puts "%10s  %s" % [x[:count], x[:group]] # locations, classes
    #   # allocations_by_location(x[:stats]).sort_by{|x|-x[:count]}.take(5).each do |y|
    #   #   io.puts "         : %10s  %s" % [y[:count], y[:group]]
    #   # end
    #   # io.puts
    # end

    io.puts "\n\nLocations with most allocations\n#{"="*64}"
    allocations_by_location.sort_by{|x| -x[:count] }.tap{log "sorted"}.take(limit).each do |x|
      io.puts "%10s  %s" % [x[:count], x[:group]] # classes, method(s)
      # allocations_by_class(x[:stats]).sort_by{|x|-x[:count]}.take(5).each do |y|
      #   io.puts "         : %10s  %s" % [y[:count], y[:group]]
      # end
      # io.puts
    end

    #io.puts "\n\nObjects with most memory used\n#{"="*64}"
    #allocations_by_class.sort_by{|x| -x[:bytes] }.take(limit).each do |x|
    #  io.puts "%10s  %s" % [human(x[:bytes]), x[:group]]
    #  allocations_by_location(x[:stats]).sort_by{|x|-x[:bytes]}.take(5).each do |y|
    #    io.puts "         : %10s  %s" % [human(y[:bytes]), y[:group]]
    #  end
    #  io.puts
    #end

    #io.puts "\n\nMethods with most memory used\n#{"="*64}"
    #allocations_by_method.sort_by{|x| -x[:bytes] }.take(limit).each do |x|
    #  io.puts "%10s  %s" % [human(x[:bytes]), x[:group]] # locations, classes
    #  allocations_by_class(x[:stats]).sort_by{|x|-x[:bytes]}.take(5).each do |y|
    #    io.puts "         : %10s  %s" % [human(y[:bytes]), y[:group]]
    #  end
    #  io.puts
    #end

    #io.puts "\n\nLocations that use most memory\n#{"="*64}"
    #allocations_by_location.sort_by{|x| -x[:bytes] }.take(limit).each do |x|
    #  io.puts "%10s  %s" % [human(x[:bytes]), x[:group]]
    #  allocations_by_class(x[:stats]).sort_by{|x|-x[:bytes]}.take(5).each do |y|
    #    io.puts "         : %10s  %s" % [human(y[:bytes]), y[:group]]
    #  end
    #  io.puts
    #end
  ensure
    io.close unless io.equal?($stdout)
  end

  UNITS = {
    0 => "B",
    3 => "kB",
    6 => "MB",
    9 => "GB",
   12 => "TB",
   15 => "PB",
   18 => "EB",
   21 => "ZB",
   24 => "YB"}.freeze

  def human(bytes)
    return "0 B" if bytes.zero?
    scale = Math.log10(bytes).div(3) * 3
    scale = 24 if scale > 24
    "%0.2f %s" % [bytes / 10.0**scale, UNITS[scale]]
  end
end

class << MemProf
  def report(options={}, &block)
    new(options).run(&block)
  end
end

def log(msg)
  $stderr.puts "%s: %s" % [Time.now.strftime("%H:%M:%S.%N"), msg]
end

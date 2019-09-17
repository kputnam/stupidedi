require "objspace"

class MemProf
  def initialize(options)
    @trace  = options[:trace]
    @ignore = options[:ignore]
    @allow  = options[:allow]
    @retain = false
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
    ObjectSpace.trace_object_allocations_stop

    allocated = allocations
    retained  = Hash.new

    if @retain
      GC.enable
      GC.start
      GC.start
      GC.start

      ObjectSpace.each_object do |o|
        next if ObjectSpace.allocation_generation(o) != @generation
        match = allocations[o.__id__]
        retained[o.__id__] = match if match
      end
    end

    ObjectSpace.trace_object_allocations_clear
    Results.new(allocated, retained)
  end

  def allocations
    results = Hash.new.compare_by_identity
    klass   = Kernel.instance_method(:class)

    ObjectSpace.each_object do |o|
      next if ObjectSpace.allocation_generation(o) != @generation

      file = ObjectSpace.allocation_sourcefile(o).to_s
      next if @ignore and @ignore.match?(file)
      next if @allow  and not @allow.match?(file)

      klass_ = klass.bind(o).call
      next if @trace and not @trace.match?(klass_)

      line   = ObjectSpace.allocation_sourceline(o)
      method = ObjectSpace.allocation_method_id(o)
      bytes  = ObjectSpace.memsize_of(o)

      results[o.__id__] = Stat.new(klass_, file, line, [file, line], method, bytes)
    end

    results
  end
end

MemProf::Stat = Struct.new(:klass, :file, :line, :location, :method, :bytes)

class MemProf::Results
  def initialize(allocated, retained)
    @allocated = allocated.values
    @retained  = retained.values
  end

  def allocations_by_class
    Hash[@allocated.group_by(&:klass).map do |klass, stats|
      [klass, {data: klass, count: stats.length, bytes: stats.sum(&:bytes)}]
    end]
  end

  def allocations_by_method
    Hash[@allocated.group_by(&:method).map do |klass, stats|
      [klass, {data: klass, count: stats.length, bytes: stats.sum(&:bytes)}]
    end]
  end

  def allocations_by_location
    Hash[@allocated.group_by(&:location).map do |klass, stats|
      [klass, {data: klass, count: stats.length, bytes: stats.sum(&:bytes)}]
    end]
  end
end

class << MemProf
  def report(options={}, &block)
    new(options).run(&block)
  end
end

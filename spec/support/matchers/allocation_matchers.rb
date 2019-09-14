module AllocationMatchers
  def allocate(limits)
    Allocation.new(:==, limits)
  end

  def allocate_at_most(limits)
    Allocation.new(:<=, limits)
  end

  def allocate_at_least(limits)
    Allocation.new(:>=, limits)
  end

  class Allocation
    def initialize(op, limits)
      @strict = limits.fetch(:strict, true)
      limits.delete(:strict)

      @op, @limits = op, Hash[limits.map{|k,v| [k.to_s, v] }]

      raise "can't load memory_profiler" unless defined? MemoryProfiler
    end

    def description
      "allocate %s %s" % [opname(@op), @limits.map{|k,v| "#{k}:#{v}" }.join(", ")]
    end

    def matches?(target)
      @allocs = measure(target)

      failed  = @limits.reject{|k,v| v.send(reverse, @allocs.fetch(k, 0)) }.keys
      extras  = @allocs.reject{|k,v| v.send(@op,     @limits.fetch(k, 0)) }.keys

      @failed  = failed
      @failed |= extras

      @failed.empty?
    end

    def failure_message
      diff = @failed.map{|k| "%d but got %d %s" %
        [@limits.fetch(k, 0), @allocs.fetch(k, 0), k] }

      "expected\n  %s" % diff.join("\n  ")
    end

    def does_not_match?(target)
      raise "don't negate"
    end

    def supports_block_expectations?
      true
    end

  private

    def reverse(op = @op)
      {:== => :==,
       :!= => :!=,
       :<  => :>,
       :>  => :<,
       :>= => :<=,
       :<= => :>=}.fetch(op.to_sym)
    end

    def opname(op = @op)
      {:== => if @strict then "only" else "" end,
       :!= => "not",
       :<  => "less than",
       :>  => "more than",
       :>= => "at least",
       :<= => "at most"}.fetch(op.to_sym)
    end

    def measure(target)
      raise TypeError, "was not given a block" unless target.is_a?(Proc)

      # Track all classes (strict), or only ones with explicit limits?
      opts = {trace: @limits.keys.map{|c| Object.const_get(c)}}
      opts.delete(:trace) if @strict

      report = MemoryProfiler.report(opts, &target)
      result = report.allocated_objects_by_class
      result.inject({}){|memo, x| memo.update(x[:data] => x[:count]) }
    end
  end
end

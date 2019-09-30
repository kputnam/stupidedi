module SmallcheckMatchers

  def smallcheck(&block)
    Smallcheck.new(block)
  end

  class Smallcheck
    def initialize(block)
      @block = block or raise "block cannot be nil"
      @fail  = nil
      @error = nil
    end

    def description
      "satisfies property"
    end

    def matches?(target)
      raise TypeError, "expected an Enumerable, got #{target.class}" \
        unless target.is_a?(Enumerable)

      if @block.arity == 1
        target.each do |x|
          begin
            unless @block.call(x)
              @fail = x
              break
            end
          rescue => e
            @fail  = x
            @error = e
            break
          end
        end
      else
        target.each do |*args|
          begin
            unless @block.call(*args)
              @fail = args
              break
            end
          rescue => e
            @fail  = args
            @error = e
            break
          end
        end
      end

      @fail.nil?
    end

    def failure_message
      if @block.arity == 1
        counterex = @fail.inspect
      else
        counterex = @fail.map(&:inspect).join(", ")
      end

      if @error.nil?
        "%s did not satisfy property" % counterex
      else
        "%s caused %s: %s while testing property" % [counterex, @error.inspect]
      end
    end

    def does_not_match?(target)
      raise "don't negate"
    end
  end
end

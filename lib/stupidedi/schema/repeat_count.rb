module Stupidedi
  module Schema

    class RepeatCount
      class Bounded < RepeatCount
        def initialize(max)
          @max = max
        end

        def include?(n)
          n <= @max
        end

        def inspect
          @max.to_s
        end
      end

      # Using an immutable singleton instance for efficiency
      Once = Class.new(Bounded) do
        def initialize
          @max = 1
        end
      end.new

      # Using an immutable singleton instance for efficiency
      Unbounded = Class.new(RepeatCount) do
        def include?(n)
          true
        end

        def inspect
          ">1"
        end
      end.new
    end

    class << RepeatCount
      #########################################################################
      # @group Constructor Methods

      def bounded(n)
        if n < 1
          raise Exception::InvalidSchemaError,
            "RepeatCount cannot be less than 1"
        elsif n == 1
          RepeatCount::Once
        else
          RepeatCount::Bounded.new(n)
        end
      end

      def unbounded
        RepeatCount::Unbounded
      end

      # @endgroup
      #########################################################################
    end

  end
end

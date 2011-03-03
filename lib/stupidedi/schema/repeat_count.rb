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

      # Singleton
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
      # @group Constructors

      def bounded(n)
        RepeatCount::Bounded.new(n)
      end

      def unbounded
        RepeatCount::Unbounded
      end

      # @endgroup
    end

  end
end

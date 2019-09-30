# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Position
    # This provides a stub that acts like a Position but doesn't compute
    # or retain any information. Because it has no state, `NoPosition.new`
    # returns the class itself, which implements `#to_s` and `#advance`.
    #
    class NoPosition
    end

    class << NoPosition
      def caller(offset = 1)
        self
      end

      def new(*args)
        self
      end

      def build(*args)
        new
      end
    end

    class << NoPosition
      # @group Singleton "instance" methods
      #########################################################################

      def to_s
        "no position info"
      end

      def inspect
        "NoPosition"
      end

      def advance(input)
        self
      end

      def ===(other)
        equal?(other)
      end

      # @endgroup
      #########################################################################
    end
  end
end

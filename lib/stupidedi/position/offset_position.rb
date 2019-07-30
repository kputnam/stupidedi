# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Position
    #
    # Tracks only the number of characters from the start of the input
    #
    # NOTE: There aren't any instances of this class, because `build` returns
    # an Integer rather than an instance of OffsetPosition. We don't need to
    # implement `advance` because there is a special case in `Input#position_at`
    # that does the work when its @position is an Integer.
    #
    class OffsetPosition
    end

    class << OffsetPosition
      def new(*args)
        raise NoMethodError, "OffsetPosition isn't meant to be instantiated"
      end

      def build(*args)
        0
      end
    end
  end
end

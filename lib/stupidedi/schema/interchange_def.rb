module Stupidedi
  module Schema

    class InterchangeDef
      # @return [String]
      abstract :id

      # @return [Array<SegmentUse>]
      abstract :segment_uses

      # @return [InterchangeVal]
      def value(segment_vals, functional_group_vals)
        InterchangeVal.new(self, segment_vals, functional_group_vals)
      end

      def empty
        InterchangeVal.new(self, [], [])
      end
    end

  end
end

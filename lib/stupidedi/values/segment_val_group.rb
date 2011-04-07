module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.12.2 Data Segment Groups
    #
    module SegmentValGroup

      # @return [LoopDef, TableDef]
      abstract :definition

      # @return [Array<SegmentVal>]
      abstract :segment_vals

      def empty?
        segment_vals.all?(&:empty?)
      end

      # @return false
      def leaf?
        false
      end
    end

  end
end

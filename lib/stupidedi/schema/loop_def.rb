module Stupidedi
  module Definitions

    # @see X222 B.1.3.12.4 Loops of Data Segments
    class LoopDef
      # @return [String]
      abstract :id

      # @return [RepetitionMax]
      abstract :repetition_max

      # @return [Array<SegmentUse>]
      abstract :segment_uses

      # @return [Array<LoopDef>]
      abstract :loop_defs

      def bounded?
        segment_uses.first.segment_def.id == "LS" and
        segment_uses.last.segment_def.id == "LE"
      end
    end

  end
end

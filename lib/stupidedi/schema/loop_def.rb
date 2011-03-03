module Stupidedi
  module Schema

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

      # @return [LoopDef, TableDef]
      abstract :parent

      # @see X222 B.1.1.3.11.1 Loop Control Segments
      # @see X222 B.1.1.3.12.4 Loops of Data Segments Bounded Loops
      def bounded?
        segment_uses.head.segment_def.id == :LS and
        segment_uses.last.segment_def.id == :LE
      end

      # @see X12.59 5.6 HL-initiated Loop
      def hierarchical?
        segment_uses.head.segment_def.id == :HL
      end
    end

  end
end

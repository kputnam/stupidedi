module Stupidedi
  module Builder_

    class LoopState < AbstractState

      def initialize(loop_val, parent, successors)
      end
    end

    class << LoopState

      # @param [SegmentTok] segment_tok the loop start segment
      #
      # This will construct a state whose successors do not include the entry
      # segment defined by the LoopDef. This means another occurrence of that
      # segment will pop this state and the parent state will create a new
      # LoopState.
      def build(segment_tok, segment_use, parent)
        segment_val = segment(segment_tok, segment_use)
        loop_def    = segment_use.parent
        loop_val    = loop_def.value(segment_val, parent.value)

        # @todo: Remove the entry segment from successor states
        LoopState.new(loop_val, parent)
      end
    end

  end
end

module Stupidedi
  module Builder_

    class LoopState < AbstractState

      # @return [Values::LoopVal]
      attr_reader :loop_val
      alias value loop_val

      # @return [TableState, LoopState]
      attr_reader :parent

      # @return [Array<Instructions>]
      attr_reader :instructions

      def initialize(loop_val, parent, instructions)
        @loop_val, @parent, @instructions =
          loop_val, parent, instructions
      end

      def pop(count)
        if count.zero?
          self
        else
          # @todo
        end
      end

      def add(segment_tok, segment_use)
        # @todo
      end
    end

    class << LoopState

      # @param [SegmentTok] segment_tok the loop start segment
      def push(segment_tok, segment_use, parent)
        segment_val = segment(segment_tok, segment_use)
        loop_def    = segment_use.parent
        loop_val    = loop_def.value(segment_val, parent.value)

        # @todo: Remove the entry segment from successor states
        LoopState.new(loop_val, parent, instructions(loop_def))
      end

      def instructions(loop_def)
        # @todo: Explain this optimization
        is = if loop_def.header_segment_uses.head.repeatable?
              sequence(loop_def.header_segment_uses)
             else
               sequence(loop_def.header_segment_uses.tail)
             end

        is.concat(lsequence(loop_def.loop_defs, is.length))
        is.concat(sequence(loop_def.trailer_segment_uses, is.length))
      end
    end

  end
end

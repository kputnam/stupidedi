module Stupidedi
  module Builder_

    class LoopState < AbstractState

      # @return [Values::LoopVal]
      attr_reader :value
      alias loop_val value

      # @return [TableState, LoopState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(value, parent, instructions)
        @value, @parent, @instructions =
          value, parent, instructions
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:value, @value),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end

      def pop(count)
        if count.zero?
          self
        else
          @parent.merge(@value).pop(count - 1)
        end
      end

      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      def add(segment_tok, segment_use)
        copy(:value => @value.append(segment(segment_tok, segment_use)))
      end

      def merge(child)
        copy(:value => @value.append(child))
      end
    end

    class << LoopState

      # @param [SegmentTok] segment_tok the loop start segment
      def push(segment_tok, segment_use, parent, reader = nil)
        segment_val = segment(segment_tok, segment_use)
        loop_def    = segment_use.parent
        loop_val    = loop_def.value(segment_val, parent.value)

        LoopState.new(loop_val, parent,
          parent.instructions.push(instructions(loop_def)))
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

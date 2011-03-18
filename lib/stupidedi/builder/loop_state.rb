module Stupidedi
  module Builder

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

      # @return [LoopState]
      def copy(changes = {})
        LoopState.new \
          changes.fetch(:value, @value),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end

      # @return [AbstractState]
      def pop(count)
        if count.zero?
          self
        else
          @parent.merge(@value).pop(count - 1)
        end
      end

      # @return [LoopState]
      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      # @return [LoopState]
      def add(segment_tok, segment_use)
        copy(:value => @value.append(segment(segment_tok, segment_use)))
      end

      # @return [LoopState]
      def merge(child)
        copy(:value => @value.append(child))
      end
    end

    class << LoopState

      # @return [LoopState]
      def push(segment_tok, segment_use, parent, reader = nil)
        segment_val = segment(segment_tok, segment_use)
        loop_def    = segment_use.parent
        loop_val    = loop_def.value(segment_val, parent.value)

        LoopState.new(loop_val, parent,
          parent.instructions.push(instructions(loop_def)))
      end

    private

      # @return [Array<Instruction>]
      def instructions(loop_def)
        @__instructions ||= Hash.new
        @__instructions[loop_def] ||= begin
        # puts "LoopDef.instructions(#{loop_def.object_id})"
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
end

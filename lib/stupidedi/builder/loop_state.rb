module Stupidedi
  module Builder

    class LoopState < AbstractState

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [TableState, LoopState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(zipper, parent, instructions)
        @zipper, @parent, @instructions =
          zipper, parent, instructions
      end

      # @return [LoopState]
      def copy(changes = {})
        LoopState.new \
          changes.fetch(:zipper, @zipper),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end
    end

    class << LoopState
      # @group Constructor Methods
      #########################################################################

      # @return [LoopState]
      def push(segment_tok, segment_use, parent, reader)
        segment_val = segment(segment_tok, segment_use)
        loop_def    = segment_use.parent
        loop_val    = loop_def.empty

        zipper = parent.zipper.
          append(loop_val).
          append_child(segment_val)

        LoopState.new(zipper, parent,
          parent.instructions.push(instructions(loop_def)))
      end

      # @endgroup
      #########################################################################

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

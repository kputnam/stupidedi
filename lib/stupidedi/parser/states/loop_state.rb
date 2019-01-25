# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    class LoopState < AbstractState
      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [Array<AbstractState>]
      attr_reader :children

      def initialize(separators, segment_dict, instructions, zipper, children)
        @separators, @segment_dict, @instructions, @zipper, @children =
          separators, segment_dict, instructions, zipper, children
      end

      # @return [LoopState]
      def copy(changes = {})
        LoopState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << LoopState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, segment_use, config)
        loop_def    = segment_use.parent
        loop_val    = loop_def.empty
        segment_val = mksegment(segment_tok, segment_use)

        zipper.append_child new(
          parent.separators,
          parent.segment_dict,
          parent.instructions.push(instructions(loop_def)),
          parent.zipper.append(loop_val).append_child(segment_val),
          [])
      end

      # @endgroup
      #########################################################################

    private

      # @return [Array<Instruction>]
      def instructions(loop_def)
        @__instructions ||= Hash.new
        @__instructions[loop_def] ||= begin
          # When first segment is repeatable, then `successors` should include
          # an {Instruction} for it; but when it's non-repeatable, there should
          # be no successor instruction for that segment.
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

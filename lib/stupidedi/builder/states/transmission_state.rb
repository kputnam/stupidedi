# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Builder

    class TransmissionState < AbstractState

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

      # @return [TransmissionState]
      def copy(changes = {})
        TransmissionState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << TransmissionState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, segment_use, config)
        zipper = zipper.append_child new(
          parent.separators,
          parent.segment_dict,
          parent.instructions.push([
            Instruction.new(:ISA, nil, 0, 0, InterchangeState)]),
          parent.zipper.dangle.last,
          [])

        InterchangeState.push(zipper, zipper.node, segment_tok, segment_use, config)
      end

      # @endgroup
      #########################################################################
    end

  end
end

# frozen_string_literal: true

module Stupidedi
  using Refinements

  module Builder

    class FailureState < AbstractState

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Array<FailureState>]
      attr_reader :children

      def initialize(separators, segment_dict, instructions, zipper, children)
        @separators, @segment_dict, @instructions, @zipper, @children =
          separators, segment_dict, instructions, zipper, children
      end

      def copy(changes = {})
        FailureState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << FailureState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, reason)
        envelope_val = Values::InvalidEnvelopeVal.new([])
        segment_val  = Values::InvalidSegmentVal.new(reason, segment_tok)

        zipper.append_child new(
          parent.separators,
          parent.segment_dict,
          parent.instructions.push([]),
          parent.zipper.append(envelope_val).append_child(segment_val),
          [])
      end

      def mksegment(segment_tok, parent)
        segment_val = Values::InvalidSegmentVal.new \
          "unexpected segment", segment_tok

        new(parent.separators,
            parent.segment_dict,
            parent.instructions,
            parent.zipper.append(segment_val),
            [])
      end

      # @endgroup
      #########################################################################
    end

  end
end

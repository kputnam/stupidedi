module Stupidedi
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

      def initialize(envelope, separators, segment_dict, instructions, zipper, children)
        @envelope, @separators, @segment_dict, @instructions, @zipper, @children =
          envelope, separators, segment_dict, instructions, zipper, children
      end

      def copy(changes = {})
        FailureState.new \
          changes.fetch(:envelope, @envelope),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @zipper)
      end

      def leaf?
        not @envelope
      end
    end

    class << FailureState

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, reason)
        envelope_val = Envelope::InvalidEnvelopeVal.new([])
        segment_val  = Values::InvalidSegmentVal.new(reason, segment_tok)

        zipper.append_child new(
          true,
          parent.separators,
          parent.segment_dict,
          parent.instructions.push([]),
          parent.zipper.append(envelope_val).append_child(segment_val),
          [])
      end
    end

  end
end

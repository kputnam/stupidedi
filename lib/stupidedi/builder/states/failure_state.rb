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

      def initialize(container, separators, segment_dict, instructions, zipper)
        @container, @separators, @segment_dict, @instructions, @zipper =
          container, separators, segment_dict, instructions, zipper
      end

      def copy(changes = {})
        FailureState.new \
          changes.fetch(:container, @container),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper)
      end

      def leaf?
        not @container
      end
    end

  end
end

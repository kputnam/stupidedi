module Stupidedi
  using Refinements

  module Builder

    class InitialState < AbstractState

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

      # @return [InitialState]
      def copy(changes = {})
        InitialState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << InitialState

      # @return [InitialState]
      def build
        new(
          Reader::Separators.empty,
          Reader::SegmentDict.empty,

          InstructionTable.build(
            # We initially accept only a single segment. When reading the "ISA"
            # segment, we push a new InterchangeState.
            Instruction.new(:ISA, nil, 0, 0, TransmissionState).cons),

          # Create a new parse tree with a Transmission as the root, and descend
          # to the placeholder where the first child node will be placed.
          Zipper.build(Values::TransmissionVal.new),
          [])
      end

      # @return [Zipper::AbstractCursor]
      def start
        Zipper.build(build)
      end
    end

  end
end

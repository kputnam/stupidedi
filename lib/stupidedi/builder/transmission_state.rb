module Stupidedi
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

      # @return [TransmissionState]
      def build
        new(Reader::Separators.empty,
            Reader::SegmentDict.empty,

            # Note: Constructing a new InstructionTable creates a separate cache
            # for memoization, allowing garbage collection. We could choose to
            # statically allocate a single table, instead.
            InstructionTable.build(
              # We initially accept only a single segment. When reading the "ISA"
              # segment, we push a new InterchangeState.
              Instruction.new(:ISA, nil, 0, 0, InterchangeState).cons),

            # Create a new parse tree with a Transmission as the root, and descend
            # to the placeholder where the first child node will be placed.
            Zipper.build(Envelope::Transmission.new).dangle,
            [])
      end

      # @return [void]
      def push
        raise Exceptions::ParseError,
          "TransmissionState#push should not be called"
      end

      # @endgroup
      #########################################################################
    end

  end
end

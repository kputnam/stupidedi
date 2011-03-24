module Stupidedi
  module Builder

    class TransmissionState < AbstractState

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [Config::RootConfig]
      attr_reader :config

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(config, separators, segment_dict, instructions, zipper)
        @config, @separators, @segment_dict, @instructions, @zipper =
          config, separators, segment_dict, instructions, zipper
      end

      # @return [TransmissionState]
      def copy(changes = {})
        TransmissionState.new \
          changes.fetch(:config, @config),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper)
      end

      def parent
        raise Exceptions::ParseError,
          "TransmissionState#parent should not be called"
      end

      def add(segment_tok, segment_use)
        raise Exceptions::ParseError,
          "TransmissionState#add should not be called"
      end

      # @return [TransmissionState]
      def pop(count)
        if count.zero?
          self
        else
          raise Exceptions::ParseError,
            "TransmissionState#pop should not be called"
        end
      end

      # @return [TransmissionState]
      def drop(count)
        if count.zero?
          self
        else
          raise Exceptions::ParseError,
            "TransmissionState#drop should not be called"
        end
      end
    end

    class << TransmissionState
      # @group Constructor Methods
      #########################################################################

      # @return [TransmissionState]
      def build(config)
        new(config,
            Reader::Separators.empty,
            Reader::SegmentDict.empty,
            InstructionTable.build(
              Instruction.new(:ISA, nil, 0, 0, InterchangeState).cons),
            Zipper.build(Envelope::Transmission.new).dangle)
      end

      # @endgroup
      #########################################################################

      # @return [void]
      def push(segment_tok, segment_use, parent, reader)
        raise Exceptions::ParseError,
          "TransmissionState.push should not be called"
      end
    end

  end
end

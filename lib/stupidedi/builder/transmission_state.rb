module Stupidedi
  module Builder

    class TransmissionState < AbstractState

      # @return [Array<InterchangeVal>]
      attr_reader :value
      alias interchange_vals value

      # @return [Configuration::RootConfig]
      attr_reader :config

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(config, separators, segment_dict, instructions = nil, value = [])
        @config, @separators, @segment_dict, @value =
          config, separators, segment_dict, value

        # From this state, we can only accept an "ISA" SegmentTok, which will
        # always push a new InterchangeState onto the stack. We can't determine
        # the SegmentUse without examining the contents of the SegmentTok, so
        # we leave it nil and let InterchangeState.push determine it.
        @instructions = instructions || 
          InstructionTable.build(
            Instruction.new(:ISA, nil, 0, 0, InterchangeState).cons)
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:config, @config),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:value, @value)
      end

      def parent
        raise "@todo: TransmissionState#parent"
      end

      def pop(count)
        if count.zero?
          self
        else
          raise "@todo: TransmissionState#pop"
        end
      end

      def drop(count)
        if count.zero?
          self
        else
          raise "@todo: TransmissionState#drop"
        end
      end

      def add(segment_tok, segment_use)
        raise "@todo: TransmissionState#add"
      end

      def merge(child)
        copy(:value => child.cons(@value))
      end
    end

  end
end

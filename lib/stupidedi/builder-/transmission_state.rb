module Stupidedi
  module Builder_

    class TransmissionState < AbstractState

      # @return [Array<InterchangeVal>]
      attr_reader :interchange_vals
      alias value interchange_vals

      # @return [Configuration::RootConfig]
      attr_reader :config

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [Array<Instruction>]
      attr_reader :instructions

      def initialize(config, separators, segment_dict, instructions = nil, interchange_vals = [])
        @config, @separators, @segment_dict, @interchange_vals =
          config, separators, segment_dict, interchange_vals

        # From this state, we can only accept an "ISA" SegmentTok, which will
        # always push a new InterchangeState onto the stack. We can't determine
        # the SegmentUse without examining the contents of the SegmentTok, so
        # we leave it nil and let InterchangeState.push determine it.
        @instructions = instructions || 
          Instruction.new(:ISA, nil, 0, 0, InterchangeState).cons
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:interchange_vals, @interchange_vals),
          changes.fetch(:config, @config),
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions)
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

      def add(segment_tok, segment_use)
        raise "@todo: TransmissionState#add"
      end

      def merge(child)
        copy(:interchange_vals => child.cons(@interchange_vals))
      end
    end

  end
end

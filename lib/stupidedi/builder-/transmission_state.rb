module Stupidedi
  module Builder_

    class TransmissionState < AbstractState

      # @return [Configuration::RootConfig]
      attr_reader :config

      # @return [Reader::Separators]
      attr_reader :separators

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [Array<Instruction>]
      attr_reader :instructions

      def initialize(config, separators, segment_dict, instructions = nil)
        @config, @separators, @segment_dict =
          config, separators, segment_dict

        # From this state, we can only accept an "ISA" SegmentTok, which will
        # always push a new InterchangeState onto the stack. We can't determine
        # the SegmentUse without examining the contents of the SegmentTok, so
        # we leave it nil and let InterchangeState.push determine it.
        @instructions = instructions || 
          Instruction.new(:ISA, nil, 0, 0, InterchangeState).cons
      end
    end

  end
end

module Stupidedi
  module Builder_

    class TransmissionState < AbstractState

      def successors
        # From this state, we can only accept an "ISA" SegmentTok, which will
        # always push a new InterchangeState onto the stack. We can't determine
        # the SegmentUse without examining the contents of the SegmentTok, so
        # we leave it nil and let InterchangeState.push determine it.
        Instruction.new(:ISA, nil, 0, 0, InterchangeState).cons
      end
    end

  end
end

module Stupidedi
  module Builder_

    class FunctionalGroupState < AbstractState

      def initialize(envelope_val, parent)
      end
    end

    class << FunctionalGroupState

      # @param [SegmentTok] segment_tok the functional group start segment
      # @param [SegmentUse] segment_use nil
      #
      # This will construct a state whose successors do not include the entry
      # segment defined by the FunctionalGroupDef (which is probably GS). This
      # means another occurrence of that segment will pop this state and the
      # parent state will create a new FunctionalGroupState.
      def build(segment_tok, segment_use, parent)
        # GS08: Version / Release / Industry Identifier Code
        version = segment_tok.element_toks.at(7).value.slice(0, 6)

        unless parent.config.functional_group.defined_at?(version)
          return FailureState.new("Unknown functional group version #{version}",
            segment_tok, parent)
        end

        envelope_def = parent.config.functional_group.at(version)
        envelope_val = envelope_def.value(segment_val, parent.value)
        segment_use  = envelope_def.header_segment_use
        segment_val  = segment(segment_tok, segment_use)

        # @todo: Remove the entry segment from successor states
        FunctionalGroupState.new(envelope_val, parent)
      end
    end

  end
end

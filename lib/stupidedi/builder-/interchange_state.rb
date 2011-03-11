module Stupidedi
  module Builder_

    class InterchangeState < AbstractState

      # @return [InterchangeVal]
      attr_reader :interchange_val

      def initialize(interchange_val, parent)
        @interchange_val = interchange_val
      end

      def pop(segment_tok, segment_use)
      end

      def advance(segment_tok, segment_use)
      end
    end

    class << InterchangeState

      # @param [SegmentTok] segment_tok the interchange start segment
      # @param [SegmentUse] segment_use nil
      #
      # This will construct a state whose successors do not include the entry
      # segment defined by the InterchangeDef (which is typically ISA). This
      # means another occurence of that segment will pop this state and the
      # parent state will create a new InterchangeState.
      def push(segment_tok, segment_use, parent)
        # ISA12: Interchange Control Version Number
        version = segment_tok.element_toks.at(11).value

        unless parent.config.interchange.defined_at?(version)
          return FailureState.new("Unknown interchange version #{version}",
            segment_tok, parent)
        end

        # Construct a SegmentVal and InterchangeVal around it
        envelope_def = parent.config.interchange.at(version)
        envelope_val = envelope_def.value(segment_val)
        segment_use  = envelope_def.header_segment_use
        segment_val  = segment(segment_tok, segment_use)

        # @todo: Remove the entry segment from successor states
        InterchangeState.new(envelope_val, parent)
      end

      def successors(interchange_val)
        interchange_def = interchange_val.definition

      end
    end

  end
end

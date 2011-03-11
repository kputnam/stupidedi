module Stupidedi
  module Builder_

    class FunctionalGroupState < AbstractState

      # @return [Envelope::FunctionalGroupVal]
      attr_reader :functional_group_val
      alias value functional_group_val

      # @return [InterchangeState]
      attr_reader :parent

      # @return [Array<Instruction>]
      attr_reader :instructions

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      def initialize(envelope_val, parent, instructions, segment_dict)
        @functional_group_val, @parent, @instructions, @segment_dict =
          functional_group_val, parent, successor, segment_dict
      end

      def pop(count)
        if count.zero?
          self
        else
          # @todo
        end
      end

      def add(segment_tok, segment_use)
        # @todo
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
      def push(segment_tok, segment_use, parent, reader = nil)
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
        FunctionalGroupState.new(envelope_val, parent,
          instructions(envelope_def),
          parent.segment_dict.push(envelope_val.segment_dict))
      end

      # @return [Array<Instruction>]
      def instructions(functional_group_def)
        is = sequence(functional_group_def.header_segment_uses.tail)
        is << Instruction.new(:ST, nil, 0, is.length, TransactionSetState)
        is.concat(sequence(functional_group_def.trailer_segment_uses, is.length))
      end
    end

  end
end

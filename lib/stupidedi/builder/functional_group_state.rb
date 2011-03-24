module Stupidedi
  module Builder

    class FunctionalGroupState < AbstractState

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [InterchangeState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      # @return [Reader::SegmentDict]
      attr_reader :segment_dict

      # @return [String]
      attr_reader :fgcode

      # @return [String]
      attr_reader :version

      def initialize(zipper, parent, instructions, segment_dict, fgcode, version)
        @zipper, @parent, @instructions, @segment_dict, @fgcode, @version =
          zipper, parent, instructions, segment_dict, fgcode, version
      end

      # @return [FunctionalGroupState]
      def copy(changes = {})
        FunctionalGroupState.new \
          changes.fetch(:zipper, @zipper),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:fgcode, @fgcode),
          changes.fetch(:version, @version)
      end
    end

    class << FunctionalGroupState
      # @group Constructor Methods
      #########################################################################

      # @return [FunctionalGroupState]
      def push(segment_tok, segment_use, parent, reader = nil)
        # GS08: Version / Release / Industry Identifier Code
        gscode  = segment_tok.element_toks.at(7).try{|t| t.value.slice(0, 6) }
        version = segment_tok.element_toks.at(7).try(:value)

        # GS01: Functional Identifier Code
        fgcode = segment_tok.element_toks.at(0).try{|t| t.value }

        unless parent.config.functional_group.defined_at?(gscode)
          return FailureState.new("Unknown functional group version #{gscode}",
            segment_tok, parent)
        end

        envelope_def = parent.config.functional_group.at(gscode)
        envelope_val = envelope_def.empty
        segment_use  = envelope_def.entry_segment_use

        zipper = parent.zipper.
          append(envelope_val).
          append_child(segment(segment_tok, segment_use))

        FunctionalGroupState.new(zipper, parent,
          parent.instructions.push(instructions(envelope_def)),
          parent.segment_dict.push(envelope_val.segment_dict),
          fgcode, version)
      end

      # @endgroup
      #########################################################################

    private

      # @return [Array<Instruction>]
      def instructions(functional_group_def)
        @__instructions ||= Hash.new
        @__instructions[functional_group_def] ||= begin
        # puts "FunctionalGroupState.instructions(#{functional_group_def.object_id})"
          is = sequence(functional_group_def.header_segment_uses.tail)
          is << Instruction.new(:ST, nil, 0, is.length, TransactionSetState)
          is.concat(sequence(functional_group_def.trailer_segment_uses, is.length))
        end
      end
    end

  end
end

# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Builder

    class FunctionalGroupState < AbstractState

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

      # @return [String]
      attr_reader :fgcode

      # @return [String]
      attr_reader :version

      def initialize(separators, segment_dict, instructions, zipper, children, fgcode, version)
        @separators, @segment_dict, @instructions, @zipper, @children, @fgcode, @version =
          separators, segment_dict, instructions, zipper, children, fgcode, version
      end

      # @return [FunctionalGroupState]
      def copy(changes = {})
        FunctionalGroupState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children),
          changes.fetch(:fgcode, @fgcode),
          changes.fetch(:version, @version)
      end
    end

    class << FunctionalGroupState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, segment_use, config)
        # GS08: Version / Release / Industry Identifier Code
        version = segment_tok.element_toks.at(7).try(:value)
        gscode  = version.try(:slice, 0, 6)

        # GS01: Functional Identifier Code
        fgcode = segment_tok.element_toks.at(0).try(:value)

        unless config.functional_group.defined_at?(gscode)
          return FailureState.push(
            zipper,
            parent,
            segment_tok,
            "unknown functional group version #{gscode.inspect}")
        end

        envelope_def = config.functional_group.at(gscode)
        envelope_val = envelope_def.empty
        segment_use  = envelope_def.entry_segment_use
        segment_val  = mksegment(segment_tok, segment_use)

        zipper.append_child new(
          parent.separators,
          parent.segment_dict.push(envelope_val.segment_dict),
          parent.instructions.push(instructions(envelope_def)),
          parent.zipper.append(envelope_val).append_child(segment_val),
          [], fgcode, version)
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

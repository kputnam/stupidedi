# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Parser
    class TransactionSetState < AbstractState
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

      def initialize(separators, segment_dict, instructions, zipper, children)
        @separators, @segment_dict, @instructions, @zipper, @children =
          separators, segment_dict, instructions, zipper, children
      end

      # @return [TransactionSetState]
      def copy(changes = {})
        TransactionSetState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << TransactionSetState
      # @group Constructors
      #########################################################################

      # @return [TransactionSetState]
      def push(zipper, parent, segment_tok, segment_use, config)
        # GS01: Functional Identifier Code
        gs01 = parent.gs01

        # ST01: Transaction Set Identifier Code
        st01 = segment_tok.element_toks.at(0).try(:value)

        # ST03: Implementation Convention Reference
        #
        # The implementation convention reference (ST03) is used by the
        # translation routines of the interchange partners to select the
        # appropriate implementation convention to match the transaction set
        # definition. When used, this implementation convention reference takes
        # precedence over the implementation reference specified in the GS08
        st03 = segment_tok.element_toks.at(2).try(:value)

        # Fall back to GS08 if ST03 isn't available
        if st03.blank? or st03.is_a?(Symbol)
          # GS08: Version / Release / Industry Identifier Code
          st03 = parent.gs08
        end

        # Fall back to GS08 if ST03 isn't recognized
        # unless config.transaction_set.defined_at?(st03, gs01, st01)
        #   if config.transaction_set.defined_at?(parent.gs08, gs01, st01)
        #     st03 = parent.gs08
        #   end
        # end

        st03 = st03.to_s
        gs01 = gs01.to_s
        st01 = st01.to_s

        unless config.transaction_set.defined_at?(st03, gs01, st01)
          context = "#{st03.inspect} #{gs01.inspect} #{st01.inspect}"

          return FailureState.push(
            zipper,
            parent,
            segment_tok,
            "unknown transaction set #{context}")
        end

        envelope_def = config.transaction_set.at(st03, gs01, st01)
        envelope_val = envelope_def.empty
        segment_use  = envelope_def.entry_segment_use

        zipper = zipper.append_child \
          TransactionSetState.new(
            parent.separators,
            parent.segment_dict,
            parent.instructions.push(instructions(envelope_def)),
            parent.zipper.append(envelope_val).dangle.last,
            [])

        TableState.push(zipper, zipper.node, segment_tok, segment_use, config)
      end

      # @endgroup
      #########################################################################

    private

      # @return [Array<Instruction>]
      def instructions(transaction_set_def)
        @__instructions ||= Hash.new
        @__instructions[transaction_set_def] ||= begin
          # When first segment is repeatable, then `successors` should include
          # an {Instruction} for it; but when it's non-repeatable, there should
          # be no successor instruction for that segment.
          if transaction_set_def.table_defs.head.repeatable?
            tsequence(transaction_set_def.table_defs)
          else
            tsequence(transaction_set_def.table_defs.tail)
          end
        end
      end
    end
  end
end

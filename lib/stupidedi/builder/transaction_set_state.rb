module Stupidedi
  module Builder

    class TransactionSetState < AbstractState

      # @return [Zipper::AbstractCursor]
      attr_reader :zipper

      # @return [FunctionalGroupState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(zipper, parent, instructions)
        @zipper, @parent, @instructions =
          zipper, parent, instructions
      end

      # @return [TransactionSetState]
      def copy(changes = {})
        TransactionSetState.new \
          changes.fetch(:zipper, @zipper),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end

      # @return [TransactionSetState]
      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      # @return [TransactionSetState]
      def add(segment_tok, segment_use)
        copy(:zipper => @zipper.append(segment(segment_tok, segment_use)))
      end
    end

    class << TransactionSetState

      # @return [TransactionSetState]
      def push(segment_tok, segment_use, parent, reader)
        # GS01: Functional Identifier Code
        fgcode = parent.fgcode

        # ST01: Transaction Set Identifier Code
        txcode = segment_tok.element_toks.at(0).try(:value)

        # ST03: Implementation Convention Reference
        version = segment_tok.element_toks.at(2).try(:value)

        if version.blank? or version.is_a?(Symbol)
          # GS08: Version / Release / Industry Identifier Code
          version = parent.zipper.node.at(7).to_s
        end

        unless parent.config.transaction_set.defined_at?(version, fgcode, txcode)
          context = "#{fgcode} #{txcode} #{version}"
          return FailureState.new("Unknown transaction set #{context}",
            segment_tok, parent)
        end

        envelope_def = parent.config.transaction_set.at(version, fgcode, txcode)
        envelope_val = envelope_def.empty
        segment_use  = envelope_def.entry_segment_use

        zipper = parent.zipper.
          append(envelope_val).
          dangle

        TableState.push(segment_tok, segment_use,
          TransactionSetState.new(zipper, parent,
            parent.instructions.push(instructions(envelope_def))), reader)
      end

    private

      # @return [Array<Instruction>]
      def instructions(transaction_set_def)
        @__instructions ||= Hash.new
        @__instructions[transaction_set_def] ||= begin
        # puts "TransactionSetState.instructions(#{transaction_set_def.object_id})"
          # @todo: Explain this optimization
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

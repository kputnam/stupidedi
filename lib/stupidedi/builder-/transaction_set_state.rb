module Stupidedi
  module Builder_

    class TransactionSetState < AbstractState

      # @return [Envelope::TransactionSetVal]
      attr_reader :value
      alias transaction_set_val value

      # @return [FunctionalGroupState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(value, parent, instructions)
        @value, @parent, @instructions =
          value, parent, instructions
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:value, @value),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end

      def pop(count)
        if count.zero?
          self
        else
          @parent.merge(@value).pop(count - 1)
        end
      end

      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      def add(segment_tok, segment_use)
        copy(:value => @value.append(segment(segment_tok, segment_use)))
      end

      def merge(child)
        copy(:value => @value.append(child))
      end
    end

    class << TransactionSetState

      def push(segment_tok, segment_use, parent, reader = nil)
        # GS01: Functional Identifier Code
        fgcode = parent.value.at(:GS).head.at(0).to_s

        # ST01: Transaction Set Identifier Code
        txcode = segment_tok.element_toks.at(0).value

        # ST03: Implementation Convention Reference
        version = segment_tok.element_toks.at(2).value

        if version.blank?
          # GS08: Version / Release / Industry Identifier Code
          version = parent.value.at(:GS).head.at(7).to_s
        end

        unless parent.config.transaction_set.defined_at?(version, fgcode, txcode)
          context = "#{fgcode} #{txcode} #{version}"
          return FailureState.new("Unknown transaction set #{context}",
            segment_tok, parent)
        end

        envelope_def = parent.config.transaction_set.at(version, fgcode, txcode)
        envelope_val = envelope_def.empty(parent.value)
        segment_use  = envelope_def.entry_segment_use

        TableState.push(segment_tok, segment_use,
          TransactionSetState.new(envelope_val, parent,
            parent.instructions.push(instructions(envelope_def))))
      end

      # @return [Array<Instruction>]
      def instructions(transaction_set_def)
        @__instructions ||= Hash.new
        @__instructions[transaction_set_def] ||= begin
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

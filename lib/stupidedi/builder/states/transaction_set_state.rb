module Stupidedi
  module Builder

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
        fgcode = parent.fgcode

        # ST01: Transaction Set Identifier Code
        txcode = segment_tok.element_toks.at(0).attempt(:value)

        # ST03: Implementation Convention Reference
        version = segment_tok.element_toks.at(2).attempt(:value)

        # Fall back to GS08 if ST03 isn't available
        if version.blank? or version.is_a?(Symbol)
          # GS08: Version / Release / Industry Identifier Code
          version = parent.version
        end

        # Fall back to GS08 if version isn't recognized
        unless config.transaction_set.defined_at?(version, fgcode, txcode)
          if config.transaction_set.defined_at?(parent.version, fgcode, txcode)
            # GS08: Version / Release / Industry Identifier Code
            version = parent.version
          end
        end

        unless config.transaction_set.defined_at?(version, fgcode, txcode)
          context = "#{fgcode.inspect} #{txcode.inspect} #{version.inspect}"

          return FailureState.push(
            zipper,
            parent,
            segment_tok,
            "unknown transaction set #{context}")
        end

        envelope_def = config.transaction_set.at(version, fgcode, txcode)
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

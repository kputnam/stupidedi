module Stupidedi
  module Builder_

    class TransactionSetState < AbstractState

      # @return [Envelope::TransactionSetVal]
      attr_reader :transaction_set_val
      alias value transaction_set_val

      # @return [FunctionalGroupState]
      attr_reader :parent

      # @return [Array<Instruction>]
      attr_reader :instructions

      def initialize(envelope_val, parent, instructions)
        @transaction_set_val, @parent, @instructions =
          envelope_val, parent, instructions
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

    class << TransactionSetState

      # @param [SegmentTok] segment_tok the transaction set start segment
      # @param [SegmentUse] segment_use nil
      #
      # This will construct a state whose successors do not include the entry
      # segment defined by the TransactionSetDef (which is typically ST). This
      # means another occurence of that segment will pop this state and the
      # parent state will create a new TransactionSetState.
      #
      # Note that a transaction set does not directly contain segments; instead,
      # it contains tables which in turn may contain segments or loops. The
      # successor states of the TransactionSetState will be the entry segments
      # defined by each table. If the segment is a direct descendant of a table,
      # a TableState will be created; otherwise the segment belongs to a loop
      # that belongs to a table, so both a TableState and LoopState are created.
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
          context = "#{group} #{txcode} #{version}"
          return FailureState.new("Unknown transaction set #{context}",
            segment_tok, parent)
        end

        envelope_def = parent.config.transaction_set.at(version, fgcode, txcode)
        envelope_val = envelope_val.empty(parent.value)
        segment_use  = envelope_def.entry_segment_use

        # Because TransactionState does not include the entry segment as one of
        # its successors, we pass it as the parent to TableState.push -- which
        # will take care of acting on the entry segment.
        ts = TransactionState.new(envelope_val, parent,
          instructions(envelope_def))

        TableState.push(segment_tok, segment_use, ts, reader)
      end

      # @return [Array<Instructions>]
      def instructions(transaction_set_def)
        is = tsequence(transaction_set_def.table_defs.tail)

        count = 0

        # Check if the grammar is parsable by this parser
        is.each do |i|
          count += 1

          # When this segment is read, the instruction is not removed
          # from the table created by TransactionSetState, so we have
          # if the same segment is in the table created by the child
          if count > i.drop
            ccount = 0

            # Construct the child state's list of instructions. These
            # will be push onto the TransactionSetState's table
            case i.segment_use.parent
            when Schema::TableDef
              # The segment directly belongs to the table, so it will only
              # instatiate a new TableState.
              cs = TableState.instructions(i.segment_use.parent)

              # We know the segment triggers a new table from here. Check if
              # the child's instructions indicate the same segment belongs to
              # the existing table.
              cs.each do |ci|
                ccount += 1

                if ccount > ci.drop and ci.segment_use.eql?(i.segment_use)
                  sid = i.segment_use.definition.id.to_s
                  sid << ": "
                  sid << i.segment_use.definition.name
                  sid = "SegmentDef[#{sid}]"

                  tid = i.segment_use.parent.parent.id
                  tid = "TableDef[#{tid}]"

                  raise Exceptions::AmbiguousGrammarError, <<-MSG.split("\n").join.squeeze(" ")
                    Successive occurrences of #{sid} may belong to the instance
                    of #{tid} created by the first occurrence or to a new
                    instance of the table. This is because both the segment and
                    table are repeatable.
                  MSG
                end
              end
            when Schema::LoopDef
              # The segment belongs to a loop, which belongs to the table,
              # so it will instatiate a TableState and then a LoopState as
              # its child
              cs = TableState.instructions(i.segment_use.parent.parent)

              # We know the segment triggers a new table from here. Check if
              # the child's instructions indicate the same segment creates a
              # new loop within the existing table.
              cs.each do |ci|
                ccount += 1

                if ccount > ci.drop and ci.segment_use.eql?(i.segment_use)
                  sid = i.segment_use.definition.id.to_s
                  sid << ": "
                  sid << i.segment_use.definition.name
                  sid = "SegmentDef[#{sid}]"

                  lid = i.segment_use.parent.id
                  lid = "LoopDef[#{lid}]"

                  tid = i.segment_use.parent.parent.id
                  tid = "TableDef[#{tid}]"

                  raise Exceptions::AmbiguousGrammarError, <<-MSG.split("\n").join.squeeze(" ")
                    Successive occurrences of #{sid} may belong to the instance
                    of #{tid} created by the first occurrence or to a new
                    instance of the table. This is because both the table and
                    #{lid} are repeatable.
                  MSG
                end
              end
            end
          end
        end

        return is
      end
    end

  end
end

module Stupidedi
  module Builder_

    class TableState < AbstractState

      # @return [Values::TableVal]
      attr_reader :table_val
      alias value table_val

      # @return [TransmissionState]
      attr_reader :parent

      # @return [Array<Instruction>]
      attr_reader :instructions

      def initialize(table_val, parent, instructions)
        @table_val, @parent, @instructions =
          table_val, parent, instructions
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:table_val, @table_val),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end

      def pop(count)
        if count.zero?
          self
        else
          @parent.merge(self).pop(count - 1)
        end
      end

      def add(segment_tok, segment_use)
        copy(:table_val =>
          @table_val.append(segment(segment_tok, segment_use)))
      end

      def merge(child)
        copy(:table_val =>
          @table_val.append(child))
      end
    end

    class << TableState

      # @param [SegmentTok] segment_tok the table set start segment
      # @param [SegmentUse] segment_use
      # @param [TransactionSetState] parent
      #
      # It is assumed that the entry segments for a table all have the same
      # defined position, and that position is the smallest position of: all
      # the segments that can occur as direct children of the table and all
      # the entry segments of loops that are direct children of the table.
      #
      # @todo: The above is wrong -- 005010X221 HP835 Table 3 begins with an
      # optional and repeatable PLB segment followed by an ST segment. This
      # means Table 3 can begin with ST alone.
      #
      # This will construct a state whose successors include all the segments
      # that are direct descendants of the table, in addition to all the entry
      # segments of every loop that is a direct descendant of the table. This
      # means consecutive occurrences of any of the table's entry segments will
      # belong to the existing table -- rather creating a new table each time
      # by popping this state and letting the parent state create a new one.
      def push(segment_tok, segment_use, parent, reader = nil)
        case segment_use.parent
        when Schema::TableDef
          segment_val = segment(segment_tok, segment_use)
          table_def   = segment_use.parent
          table_val   = table_def.value(segment_val, parent.value)

          ptable = parent.instructions
          pstart = ptable.at(segment_use)

          ttable = instructions(table_def)
          tstart = ttable.at(segment_use)

          TableState.new(table_val, parent,
            ptable.drop(pstart.try(:drop_count) || 0).
              concat(ttable.drop(tstart.drop_count)))
        when Schema::LoopDef
          table_def   = segment_use.parent.parent
          table_val   = table_def.empty(parent.value)

          ptable = parent.instructions
          pstart = ptable.at(segment_use)

          LoopState.push(segment_tok, segment_use,
            TableState.new(table_val, parent,
              ptable.drop(pstart.try(:drop_count) || 0).
                concat(ttable.drop(tstart.drop_count))))
        end
      end

      # @return [InstructionTable]
      def instructions(table_def)
        @__instructions ||= Hash.new
        @__instructions[table_def] ||= begin
          is = sequence(table_def.header_segment_uses)
          is.concat(lsequence(table_def.loop_defs, is.length))
          is.concat(sequence(table_def.trailer_segment_uses, is.length))

          InstructionTable.build(is)
        end
      end

    end

  end
end

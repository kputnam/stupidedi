module Stupidedi
  module Builder_

    class TableState < AbstractState

      # @return [Values::TableVal]
      attr_reader :value
      alias table_val value

      # @return [TransmissionState]
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

          TableState.new(table_val, parent,
            parent.instructions.push(instructions(table_def)))
        when Schema::LoopDef
          table_def   = segment_use.parent.parent
          table_val   = table_def.empty(parent.value)

          LoopState.push(segment_tok, segment_use,
            TableState.new(table_val, parent,
              parent.instructions.push(instructions(table_def))))
        end
      end

      # @return [InstructionTable]
      def instructions(table_def)
        @__instructions ||= Hash.new
        @__instructions[table_def] ||= begin
          is = sequence(table_def.header_segment_uses)
          is.concat(lsequence(table_def.loop_defs, is.length))
          is.concat(sequence(table_def.trailer_segment_uses, is.length))
        end
      end

    end

  end
end

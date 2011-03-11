module Stupidedi
  module Builder_

    class TableState < AbstractState

      # @return [Values::TableVal]
      attr_reader :table_val
      alias value loop_val

      # @return [TransmissionState]
      attr_reader :parent

      # @return [Array<Instruction>]
      attr_reader :instructions

      def initialize(table_val, parent, instructions)
        @table_val, @parent, @instructions =
          table_val, parent, instructions
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

    class << TableState

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
          # The segment is a direct descendant of the table
          segment_val = segment(segment_tok, segment_use)
          table_def   = segment_use.parent
          table_val   = table_def.value(segment_val, parent.value)

          TableState.new(table_val, parent,
            instructions(table_def))
        when Schema::LoopDef
          table_def   = segment_use.parent.parent
          table_val   = table_def.empty(parent.value)

          LoopState.push(segment_tok, segment_use,
            TableState.new(table_val, parent,
              instructions(table_def)),
            reader)
        end
      end

      # @return [Array<Instruction>]
      def instructions(table_def)
        # @todo: Drop all the instructions before and -- depending on the
        # repeat count of the segment/loop/table -- including parsed segment.
        table_def.header_segment_uses.each do |use|
          Instruction.new(nil, use, 0, x, nil)
        end

        table_def.loop_defs.each do |l|
          use = l.entry_segment_use
          Instruction.new(nil, use, 0, x, LoopState)
        end

        table_def.trailer_segment_uses.each do |u|
          Instruction.new(nil, use, 0, x, nil)
        end
      end
    end

  end
end

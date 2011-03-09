module Stupidedi
  module Builder_

    class TableState < AbstractState
    end

    class << TableState

      # It is assumed that the entry segments for a table all have the same
      # defined position, and that position is the smallest position of: all
      # the segments that can occur as direct children of the table and all
      # the entry segments of loops that are direct children of the table.
      #
      # This will construct a state whose successors include all the segments
      # that are direct descendants of the table, in addition to all the entry
      # segments of every loop that is a direct descendant of the table. This
      # means consecutive occurrences of any of the table's entry segments will
      # belong to the existing table -- rather creating a new table each time
      # by popping this state and letting the parent state create a new one.
      def build(segment_tok, segment_use, parent)
        case segment_use.parent
        when Schema::TableDef
          # The segment is a direct descendant of the table
          segment_val = segment(segment_tok, segment_use)
          table_def   = segment_use.parent
          table_val   = table_def.value(segment_val, parent.value)

          # @todo: Remove the entry segment from successor states
          TableState.new(table_val, parent)
        when Schema::LoopDef
          table_def   = segment_use.parent.parent
          table_val   = table_def.empty(parent.value)

          # We assume this table doesn't have any header segments, and the first
          # segment belongs to a child loop. Because we already know this, we'll
          # construct the LoopState as a child of the TableState. LoopState will
          # take care of acting on the entry segment.
          LoopState.build(segment_tok, segment_use,
            TableState.new(table_val, parent))
        end
      end
    end

  end
end

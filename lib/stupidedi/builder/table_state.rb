module Stupidedi
  module Builder

    class TableState < AbstractState

      # @return [Zipper::AbstractZipper]
      attr_reader :zipper

      # @return [TransmissionState]
      attr_reader :parent

      # @return [InstructionTable]
      attr_reader :instructions

      def initialize(zipper, parent, instructions)
        @zipper, @parent, @instructions =
          zipper, parent, instructions
      end

      # @return [TableState]
      def copy(changes = {})
        TableState.new \
          changes.fetch(:zipper, @zipper),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end
    end

    class << TableState

      # @return [TableState]
      def push(segment_tok, segment_use, parent, reader)
        case segment_use.parent
        when Schema::TableDef
          segment_val = segment(segment_tok, segment_use)
          table_def   = segment_use.parent
          table_val   = table_def.empty

          zipper = parent.zipper.
            append(table_val).
            append_child(segment_val)

          itable = InstructionTable.build(instructions(table_def))
          itable = itable.drop(itable.at(segment_use).drop_count)

          TableState.new(zipper, parent,
            parent.instructions.push(itable.instructions))
        when Schema::LoopDef
          table_def = segment_use.parent.parent
          table_val = table_def.empty

          itable = InstructionTable.build(instructions(table_def))
          itable = itable.drop(itable.at(segment_use).drop_count)

          zipper = parent.zipper.
            append(table_val).
            dangle

          LoopState.push(segment_tok, segment_use,
            TableState.new(zipper, parent,
              parent.instructions.push(itable.instructions)), reader)
        end
      end

    private

      # @return [Array<Instruction]
      def instructions(table_def)
        @__instructions ||= Hash.new
        @__instructions[table_def] ||= begin
        # puts "TableState.instructions(#{table_def.object_id})"
          is = sequence(table_def.header_segment_uses)
          is.concat(lsequence(table_def.loop_defs, is.length))
          is.concat(sequence(table_def.trailer_segment_uses, is.length))
        end
      end

    end

  end
end

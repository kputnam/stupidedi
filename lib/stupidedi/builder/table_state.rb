module Stupidedi
  module Builder

    class TableState < AbstractState

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

      # @return [TableState]
      def copy(changes = {})
        TableState.new \
          changes.fetch(:separators, @separators),
          changes.fetch(:segment_dict, @segment_dict),
          changes.fetch(:instructions, @instructions),
          changes.fetch(:zipper, @zipper),
          changes.fetch(:children, @children)
      end
    end

    class << TableState
      # @group Constructors
      #########################################################################

      # @return [Zipper::AbstractCursor]
      def push(zipper, parent, segment_tok, segment_use, config)
        case segment_use.parent
        when Schema::TableDef
          table_def   = segment_use.parent
          table_val   = table_def.empty
          segment_val = mksegment(segment_tok, segment_use)

          itable = InstructionTable.build(instructions(table_def))
          itable = itable.drop(itable.at(segment_use).drop_count)

          zipper.append_child \
            TableState.new(
              parent.separators,
              parent.segment_dict,
              parent.instructions.push(itable.instructions),
              parent.zipper.append(table_val).append_child(segment_val),
              [])

        when Schema::LoopDef
          table_def = segment_use.parent.parent
          table_val = table_def.empty

          itable = InstructionTable.build(instructions(table_def))
          itable = itable.drop(itable.at(segment_use).drop_count)

          zipper = zipper.append_child \
            TableState.new(
              parent.separators,
              parent.segment_dict,
              parent.instructions.push(itable.instructions),
              parent.zipper.append(table_val).dangle,
              [])

          LoopState.push(zipper, zipper.node, segment_tok, segment_use, config)
        end
      end

      # @endgroup
      #########################################################################

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

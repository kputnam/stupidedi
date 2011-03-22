module Stupidedi
  module Builder

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

      # @return [TableState]
      def copy(changes = {})
        TableState.new \
          changes.fetch(:value, @value),
          changes.fetch(:parent, @parent),
          changes.fetch(:instructions, @instructions)
      end

      def pinch
        @parent.merge(@value).pinch
      end

      #########################################################################
      # @group Nondestructive Methods

      # @return [AbstractState]
      def pop(count)
        if count.zero?
          self
        else
          @parent.merge(@value).pop(count - 1)
        end
      end

      # @return [TableState]
      def drop(count)
        if count.zero?
          self
        else
          copy(:instructions => @instructions.drop(count))
        end
      end

      # @return [TableState]
      def add(segment_tok, segment_use)
        copy(:value => @value.append(segment(segment_tok, segment_use)))
      end

      # @return [TableState]
      def merge(child)
        copy(:value => @value.append(child))
      end

      # @endgroup
      #########################################################################

      #########################################################################
      # @group Destructive Methods

      # @return [AbstractState]
      def pop!(count)
        if count.zero?
          self
        else
          @parent.merge!(@value).pop!(count - 1)
        end
      end

      # @return [TableState]
      def drop!(count)
        unless count.zero?
          @instructions = @instructions.drop(count)
        end
        self
      end

      # @return [TableState]
      def add!(segment_tok, segment_use)
        @value.append!(segment(segment_tok, segment_use))
        self
      end

      # @return [TableState]
      def merge!(child)
        @value.append!(child)
        self
      end

      # @endgroup
      #########################################################################
    end

    class << TableState

      # @return [TableState]
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

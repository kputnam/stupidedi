module Stupidedi
  module Builder

    class TableBuilder < AbstractState
      
      # @return [TableVal]
      attr_reader :value

      # @return [TransactionSetBuilder]
      attr_reader :predecessor

      def initialize(position, table_val, predecessor)
        @position, @value, @predecessor =
          position, table_val, predecessor
      end

      # @return [TableBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      # @return [TableBuilder]
      def merge(loop_val)
        copy(:value => @value.append_loop(loop_val))
      end

      # @return [Array<AbstractState>]
      def segment(name, elements, upward = true)
        d = @value.definition

        states = d.header_segment_uses.inject([]) do |list, u|
          if @position <= u.position and name == u.definition.id
            value = @value.append_trailer_segment(construct(u, elements))
            list.push(copy(:position => u.position, :value => value))
          else
            list
          end
        end

        states = d.trailer_segment_uses.inject(states) do |list, u|
          if @position <= u.position and name == u.definition.id
            value = @value.append_trailer_segment(construct(u, elements))
            list.push(copy(:position => u.position, :value => value))
          else
            list
          end
        end

        states = d.loop_defs.inject(states) do |list, l|
          u = l.start_segment_use

          if @position <= u.position and name == u.definition.id
            loop_builder = LoopBuilder.start(l, copy(:position => u.position))
            list.concat(loop_builder.segment(name, elements, false))
          else
            list
          end
        end

        if upward
          states.concat(@predecessor.merge(@value).segment(name, elements))
        end

        branches(states)
      end

      # @private
      def pretty_print(q)
        q.text("TableBuilder[#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << TableBuilder
      def start(table_def, predecessor)
        position = table_def.start_segment_use.position
        new(position, table_def.empty(predecessor.value), predecessor)
      end
    end

  end
end

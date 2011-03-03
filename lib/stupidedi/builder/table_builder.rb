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
          if @position <= u.position and match?(u, name, elements)
            value = @value.append_header_segment(mksegment(u, elements))
            list.push(copy(:position => u.position, :value => value))
          else
            list
          end
        end

        d.loop_defs.each do |l|
          l.entry_segment_uses.each do |u|
            if @position <= u.position and match?(u, name, elements)
              states.push(LoopBuilder.start(mksegment(u, elements),
                                            copy(:position => u.position)))
            end
          end
        end

        d.trailer_segment_uses do |u|
          if @position <= u.position and match?(u, name, elements)
            value = @value.append_trailer_segment(mksegment(u, elements))
            states.push(copy(:position => u.position, :value => value))
          end
        end

        if upward
          uncles = @predecessor.merge(@value).segment(name, elements, true, d)
          states.concat(uncles.reject(&:stuck?))
        end

        if states.empty?
          failure("Unexpected segment #{name}")
        else
          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("TableBuilder[@#{@position}]")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << TableBuilder
      def start(table_def, predecessor)
        position = table_def.entry_segment_uses.head.position
        new(position, table_def.empty(predecessor.value), predecessor)
      end
    end

  end
end

module Stupidedi
  module Builder

    class TransactionSetBuilder < AbstractState

      # @return [TransactionSetVal]
      attr_reader :value

      def initialize(position, transaction_set_val, predecessor)
        @position, @value, @predecessor =
          position, transaction_set_val, predecessor
      end

      # @return [TransactionSetBuilder]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:position, @position),
          changes.fetch(:value, @value),
          changes.fetch(:predecessor, @predecessor)
      end

      # @return [TransactionSetBuilder]
      def merge(table_val)
        copy(:value => @value.append_table(table_val))
      end

      # @return [Array<AbstractState>]
      def segment(name, elements, upward = true, downward = nil)
        states = @value.definition.table_defs.inject([]) do |list, t|
          unless t.eql?(downward)
            t.entry_segment_uses.each do |u|
              if @position <= t.position and match?(u, name, elements)
                table_builder = TableBuilder.start(t, copy(:position => t.position))
                list.concat(table_builder.segment(name, elements, false))
              end
            end
          end
          
          list
        end

        if upward
          uncles = @predecessor.merge(@value).segment(name, elements)
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
        q.text("TransactionSetBuilder")
        q.group(2, "(", ")") do
          q.breakable ""
          q.pp @value
        end
      end
    end

    class << TransactionSetBuilder
      def start(transaction_set_val, predecessor)
        position = transaction_set_val.definition.table_defs.head.position
        new(position, transaction_set_val, predecessor)
      end
    end

  end
end

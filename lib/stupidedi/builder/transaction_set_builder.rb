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
      def segment(name, elements, upward = true)
        states = @value.definition.table_defs.inject([]) do |list, t|
          if @position <= t.position
            table_builder = TableBuilder.start(t, copy(:position => t.position))
            list.concat(table_builder.segment(name, elements, false))
          else
            list
          end
        end

        if upward
          uncles = @predecessor.merge(@value).segment(name, elements)
          states.concat(uncles.reject(&:stuck?))
        end

        if states.empty?
          return failure("Unexpected segment #{name}")
        end

        branches(states)
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

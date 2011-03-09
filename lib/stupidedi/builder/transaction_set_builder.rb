module Stupidedi
  module Builder

    class TransactionSetBuilder < AbstractState

      # @return [TransactionSetVal]
      attr_reader :value

      # @return [FunctionalGroupBuilder]
      attr_reader :predecessor

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

      def terminate
        @predecessor.merge(@value).terminate
      end

      # @return [Array<AbstractState>]
      def successors(segment_tok, upward = true)
        states = @value.definition.table_defs.inject([]) do |list, t|
          t.entry_segment_uses.each do |u|
            if @position <= t.position and match?(u, segment_tok)
              position = (t.repeatable?) ? t.position : t.position + 1

              table_builder = TableBuilder.start(t, copy(:position => position))
              list.concat(table_builder.successors(segment_tok, false))
            end
          end

          list
        end

        if upward
          uncles = @predecessor.merge(@value).successors(segment_tok)
          states.concat(uncles.reject(&:stuck?))
        end

        if states.empty?
          failure("Unexpected segment", segment_tok)
        else
          branches(states)
        end
      end

      # @private
      def pretty_print(q)
        q.text("TransactionSetBuilder[@#{@position}]")
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

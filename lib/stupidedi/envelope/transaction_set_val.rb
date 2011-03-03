module Stupidedi
  module Envelope

    class TransactionSetVal

      # @return [TransactionSetDef]
      attr_reader :definition

      # @return [FunctionalGroupVal]
      attr_reader :parent

      def initialize(definition, table_vals, parent)
        @definition, @table_vals, @parent = definition, table_vals, parent

        @table_vals = @table_vals.map{|x| x.copy(:parent => self) }
      end

      # @return [TransactionSetVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:table_vals, @table_vals),
          changes.fetch(:parent, @parent)
      end

      # @return [TransactionSetVal]
      def append_table(table_val)
        copy(:table_vals => table_val.snoc(@table_vals))
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.functional_group}#{d.id}]" }
        q.text("TransactionSetVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @table_vals.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @private
      def ==(other)
        other.definition == @definition and
        other.table_vals == @table_vals
      end
    end

  end
end

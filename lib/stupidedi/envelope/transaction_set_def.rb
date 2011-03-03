module Stupidedi
  module Schema

    class TransactionSetDef
      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :functional_group

      # @return [Array<TableDef>]
      attr_reader :table_defs

      def initialize(functional_group, id, *table_defs)
        @functional_group, @id, @table_defs =
          functional_group, id, table_defs
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:functional_group, @functional_group),
          changes.fetch(:id, @id),
          *changes.fetch(:table_defs, @table_defs)
      end
    end

  end
end

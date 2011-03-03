module Stupidedi
  module Envelope

    class TransactionSetDef
      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :functional_group

      # @return [Array<TableDef>]
      attr_reader :table_defs

      def initialize(functional_group, id, table_defs)
        @functional_group, @id, @table_defs =
          functional_group, id, table_defs

        @table_defs = table_defs.map{|x| x.copy(:parent => self) }
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:functional_group, @functional_group),
          changes.fetch(:id, @id),
          changes.fetch(:table_defs, @table_defs)
      end

      # @private
      def pretty_print(q)
        q.text("TransactionSetDef[#{@functional_group}#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @table_defs.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << TransactionSetDef
      def build(functional_group, id, *table_defs)
        new(functional_group, id, table_defs)
      end
    end

  end
end

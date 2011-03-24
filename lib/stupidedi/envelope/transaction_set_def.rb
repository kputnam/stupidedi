module Stupidedi
  module Envelope

    class TransactionSetDef
      include Inspect

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
        TransactionSetDef.new \
          changes.fetch(:functional_group, @functional_group),
          changes.fetch(:id, @id),
          changes.fetch(:table_defs, @table_defs)
      end

      # @return [TransactionSetVal]
      def empty
        TransactionSetVal.new(self, [])
      end

      # @return [SegmentUse]
      def entry_segment_use
        @table_defs.head.header_segment_uses.head
      end

      # @return [SegmentUse]
      def first_segment_use
        @table_defs.head.header_segment_uses.head
      end

      # @return [SegmentUse]
      def last_segment_use
        @table_defs.last.trailer_segment_uses.last
      end

      # @return [void]
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

      # @return [TransactionSetDef]
      def build(functional_group, id, *table_defs)
        new(functional_group, id, table_defs)
      end
    end

  end
end

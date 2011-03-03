module Stupidedi
  module Schema

    class TableDef
      # @return [String]
      attr_reader :id

      # @return [Array<SegmentUse>]
      attr_reader :segment_uses

      # @return [Array<LoopDef>]
      attr_reader :loop_defs

      # @todo
      # @return [TransactionSetDef]
      attr_reader :parent

      def initialize(id, children)
        @id, @children = id, children
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:children, @children)
      end

      # @private
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end
    end

    class << TableDef
      def build(id, *children)
        new(id, children)
      end
    end

  end
end

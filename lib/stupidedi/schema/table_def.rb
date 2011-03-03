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

      def initialize(id, segment_uses, loop_defs)
        @id, @segment_uses, @loop_defs = id, segment_uses, loop_defs
      end

      def copy(changes = {})
        self.class.new \
          changes.fetch(:id, @id),
          changes.fetch(:segment_uses, @segment_uses),
          changes.fetch(:loop_defs, @loop_defs)
      end

      # @private
      def pretty_print(q)
        q.text("TableDef[#{@id}]")
        q.group(2, "(", ")") do
          q.breakable ""
          @segment_uses.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end

          @loop_defs.each do |e|
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
      def build(id, *args)
        segment_uses = args.take_while{|x| x.is_a?(SegmentUse) }
        loop_defs    = args.drop(segment_uses.length)

        new(id, segment_uses, loop_defs)
      end
    end

  end
end

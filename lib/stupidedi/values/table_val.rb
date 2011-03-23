module Stupidedi
  module Values

    class TableVal < AbstractVal
      include SegmentValGroup

      # @return [TableDef]
      attr_reader :definition

      # @return [Array<SegmentVal, LoopVal>]
      attr_reader :children

      # @return [TransactionSetVal]
      attr_reader :parent

      def initialize(definition, children, parent)
        @definition, @children, @parent =
          definition, children, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @children = children.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [TableVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(SegmentVal) }
      end

      def empty?
        @children.all(&:empty?)
      end

      # @return [TableVal]
      def append(child_val)
        copy(:children => child_val.snoc(@children))
      end
      alias append_loop append
      alias append_segment append

      # @return [TableVal]
      def append!(child_val)
        @children = child_val.snoc(@children)
        self
      end
      alias append_loop! append!
      alias append_segment! append!

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|t| "[#{t.id}]" }
        q.text("TableVal#{id}")
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

      # @return [String]
      def inspect
        "TableVal(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.children == @children
      end
    end

  end
end

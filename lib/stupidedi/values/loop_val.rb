module Stupidedi
  module Values

    #
    # @see X222.pdf B.1.1.3.12.2 Data Segment Groups
    # @see X222.pdf B.1.1.3.12.4 Loops of Data Segments
    #
    class LoopVal < AbstractVal
      include SegmentValGroup

      # @return [LoopDef]
      attr_reader :definition

      # @return [Array<SegmentVal, LoopVal>]
      attr_reader :children

      # @return [LoopVal, TableVal]
      attr_reader :parent

      def initialize(definition, children, parent)
        @definition, @children, @parent =
          definition, children, parent

        # Delay re-parenting until the entire value tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @children = children.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [LoopVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:parent, @parent)
      end

      # @return false
      def leaf?
        false
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @children.select{|x| x.is_a?(SegmentVal) }
      end

      def empty?
        @children.all(&:empty?)
      end

      # @return [LoopVal]
      def append(child_val)
        copy(:children => child_val.snoc(@children))
      end
      alias append_loop append
      alias append_segment append

      # @return [LoopVal]
      def append!(child_val)
        @children = child_val.snoc(@children)
        self
      end
      alias append_loop! append!
      alias append_segment! append!

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|l| "[#{l.id}]" }
        q.text("LoopVal#{id}")
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
        "LoopVal(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        other.definition == @definition and
        other.children == @children
      end
    end

  end
end

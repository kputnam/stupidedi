module Stupidedi
  module Values

    class TableVal < AbstractVal
      include SegmentValGroup

      # @return [TableDef]
      attr_reader :definition

      # @return [Array<SegmentVal, LoopVal>]
      attr_reader :children

      def initialize(definition, children)
        @definition, @children =
          definition, children
      end

      # @return [TableVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children)
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
        "Table(#{@children.map(&:inspect).join(', ')})"
      end

      # @return [Boolean]
      def ==(other)
        eql?(other) or
         (other.definition == @definition and
          other.children   == @children)
      end
    end

  end
end

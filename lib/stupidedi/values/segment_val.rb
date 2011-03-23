module Stupidedi
  module Values

    # @see X222 B.1.1.3.4 Data Segment
    class SegmentVal < AbstractVal

      # @return [SegmentDef]
      attr_reader :definition

      # @return [Array<ElementVal>]
      attr_reader :children

      # @return [SegmentUse]
      attr_reader :usage

      def initialize(definition, children, usage)
        @definition, @children, @usage =
          definition, children, usage
      end

      # @return [SegmentVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:children, @children),
          changes.fetch(:usage, @usage)
      end

      # @return false
      def leaf?
        false
      end

      def empty?
        @children.all?(&:empty?)
      end

      def defined_at?(n)
        @definition.try{|d| d.element_uses.defined_at?(n) }
      end

      # @return [SimpleElementVal, CompositeElementVal, RepeatedElementVal]
      def at(n)
        raise IndexError unless @definition.nil? or defined_at?(n)

        if @children.defined_at?(n)
          @children.at(n)
        else
          @definition.element_uses.at(n).definition.blank
        end
      end

      # @return [void]
      def pretty_print(q)
        id = @definition.try{|d| "[#{d.id}: #{d.name}]" }

        q.text("SegmentVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @children.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @return [String]
      def inspect
        @definition.id
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

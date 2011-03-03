module Stupidedi
  module Values

    # @see X222 B.1.1.3.2 Repeating Data Elements
    class RepeatedElementVal < AbstractVal
      # @return [CompositeElementDef, SimpleElementDef]
      attr_reader :definition

      # @return [Array<ElementVal>]
      attr_reader :element_vals

      # @return [SegmentVal]
      attr_reader :parent

      def initialize(definition, element_vals, parent)
        @definition, @element_vals, @parent = definition, element_vals, parent

        # Delay re-parenting until the entire definition tree has a root
        # to prevent unnecessarily copying objects
        unless parent.nil?
          @element_vals = @element_vals.map{|x| x.copy(:parent => self) }
        end
      end

      # @return [RepeatedElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:element_vals, @element_vals),
          changes.fetch(:parent, @parent)
      end

      def length
        @element_vals.length
      end

      # Returns the occurence at the given index. Numbering begins at zero.
      def at(n)
        @element_vals.at(n)
      end

      def defined_at?(n)
        @element_vals.defined_at?(n)
      end

      def empty?
        @element_vals.empty?
      end

      def append(element_val)
        RepeatedElementVal.new(@definition, element_val.snoc(@element_vals), @parent)
      end

      def prepend(element_val)
        RepeatedElementVal.new(@definition, element_val.cons(@element_vals), @parent)
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|e| "[#{e.id}]" }
        q.text("RepeatedElementVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @element_vals.each do |e|
            unless q.current_group.first?
              q.text ", "
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @private
      def ==(other)
        other.definition == @definition and
        other.element_vals == @element_vals
      end
    end

  end
end

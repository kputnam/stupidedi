module Stupidedi
  module Values

    # @see X222 B.1.1.3.3 Composite Data Structure
    class CompositeElementVal < AbstractVal
      # @return [CompositeElementDef]
      attr_reader :definition

      # @return [Array<SimpleElementVal>]
      attr_reader :component_element_vals

      # @return [SegmentVal]
      attr_reader :parent

      def initialize(definition, component_element_vals, parent)
        @definition, @component_element_vals, @parent =
          definition, component_element_vals, parent
      end

      # @return [CompositeElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:component_element_vals, @component_element_vals),
          changes.fetch(:parent, @parent)
      end

      def empty?
        @component_element_vals.all?(&:empty?)
      end

      # @return [SimpleElementVal]
      def at(n)
        if @definition.component_element_uses.defined_at?(n)
          if @component_element_vals.defined_at?(n)
            @component_element_vals.at(n)
          else
            @definition.component_element_uses.at(n).empty
          end
        else
          raise IndexError
        end
      end

      # @return [CompositeElementVal]
      def append(component_val)
        copy(:component_element_vals => component_val.snoc(@component_element_vals))
      end

      # @return [CompositeElementVal]
      def prepend(component_val)
        copy(:component_element_vals => component_val.cons(@component_element_vals))
      end

      # @return [RepeatedElementVal]
      def repeated
        RepeatedElementVal.new(@definition, [self], @parent)
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|e| "[#{e.id}]" }
        q.text("CompositeElementVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @component_element_vals.each do |e|
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
        other.component_element_vals == @component_element_vals
      end
    end

  end
end

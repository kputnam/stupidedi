module Stupidedi
  module Schema

    # @see X222 B.1.1.3.1 Data Element
    class SimpleElementDef
      # @return [String]
      abstract :id

      # @return [String]
      abstract :name

      # @return [String]
      abstract :purpose

      # @return [SimpleElementUse, ComponentElementUse]
      abstract :usage

      # @return [SimpleElementVal]
      abstract :value, :args => %w(object)

      # @return [SimpleElementVal]
      abstract :empty

      def simple?
        true
      end

      def composite?
        false
      end

      def simple_use(requirement_designator, repeat_count)
      end
    end

    # @see X222 B.1.1.3.3 Composite Data Structure
    class CompositeElementDef
      # @return [String]
      abstract :id

      # @return [String]
      abstract :name

      # @return [String]
      abstract :purpose

      # @return [Array<ComponentElementUse>]
      abstract :component_element_uses

      # @return [Array<SyntaxNote>]
      abstract :syntax_notes

      # @return [CompositeElementUse]
      abstract :usage

      def simple?
        false
      end

      def composite?
        true
      end

      # @return [CompositeElementVal]
      def value(component_element_vals, parent)
        CompositeElementVal.new(self, component_element_vals, parent)
      end

      # @return [CompositeElementVal]
      def empty(parent)
        CompositeElementVal.new(self, [], parent)
      end
    end

  end
end

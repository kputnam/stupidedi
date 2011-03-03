module Stupidedi
  module Definitions

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
    end

  end
end

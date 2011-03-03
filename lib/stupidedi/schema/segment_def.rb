module Stupidedi
  module Definitions

    class SegmentDef
      # @return [String]
      abstract :id

      # @return [String]
      abstract :name

      # @return [String]
      abstract :purpose

      # @return [Array<SimpleElementUse, CompositeElementUse>]
      abstract :element_uses

      # @return [Array<SyntaxNote>]
      abstract :syntax_notes
    end

  end
end

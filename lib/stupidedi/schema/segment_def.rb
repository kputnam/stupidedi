module Stupidedi
  module Schema

    class SegmentDef
      # @return [Symbol]
      abstract :id

      # @return [String]
      abstract :name

      # @return [String]
      abstract :purpose

      # @return [Array<SimpleElementUse, CompositeElementUse>]
      abstract :element_uses

      # @return [Array<SyntaxNote>]
      abstract :syntax_notes

      # @return [SegmentUse]
      abstract :usage

      # @return [SegmentVal]
      def empty(parent)
        SegmentVal.new(self, [], parent)
      end

      def value(element_vals, parent)
        SegmentVal.new(self, element_vals, parent)
      end
    end

  end
end

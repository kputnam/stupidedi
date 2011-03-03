module Stupidedi
  module Values

    # @see X222 B.1.1.3.1 Data Element
    class SimpleElementVal < AbstractVal
      # @return [SimpleElementDef]
      attr_reader :definition

      # @return [SegmentVal, CompositeElementVal]
      attr_reader :parent

      def initialize(definition, parent)
        @definition, @parent = definition, parent
      end

      # @return [SimpleElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:parent, @parent)
      end

      # @return [RepeatedElementVal]
      def repeated
        RepeatedElementVal.new(@definition, [self], @parent)
      end
    end

  end
end

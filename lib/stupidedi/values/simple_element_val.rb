module Stupidedi
  module Values

    #
    # @see X222 B.1.1.3.1 Data Element
    #
    class SimpleElementVal < AbstractVal

      # @return [SimpleElementDef]
      attr_reader :definition

      # @return [SegmentVal, CompositeElementVal]
      attr_reader :parent

      # @return [SimpleElementUse, ComponentElementUse]
      attr_reader :usage

      def initialize(definition, parent, usage)
        @definition, @parent, @usage =
          definition, parent, usage
      end

      # @return [SimpleElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:parent, @parent),
          changes.fetch(:usage, @usage)
      end

      # @return [RepeatedElementVal]
      def repeated
        RepeatedElementVal.new(@definition, [self], @parent)
      end
    end

  end
end

module Stupidedi
  module Values

    #
    # @see X222 B.1.1.3.1 Data Element
    #
    class SimpleElementVal < AbstractElementVal

      # @return [SimpleElementDef]
      delegate :definition, :to => :@usage

      abstract :valid?

      # @return [SegmentVal, CompositeElementVal]
      attr_reader :parent

      # @return [SimpleElementUse, ComponentElementUse]
      attr_reader :usage

      def initialize(usage)
        @usage = usage
      end

      # @return [SimpleElementVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:usage, @usage)
      end

      # @return true
      def leaf?
        true
      end
    end

  end
end

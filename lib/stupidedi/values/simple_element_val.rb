module Stupidedi
  module Values

    #
    # @abstract This must be subclassed to add type- and version-specific
    #   functionality. For instance, DateVal adds `#day`, `#month`, etc.
    #
    # @see X222 B.1.1.3.1 Data Element
    #
    class SimpleElementVal < AbstractElementVal

      # @return [SimpleElementDef]
      delegate :definition, :to => :@usage

      abstract :valid?

      # @return [SimpleElementUse, ComponentElementUse]
      attr_reader :usage

      def initialize(usage)
        @usage = usage
      end

      # @return [SimpleElementVal]
      abstract :copy, "changes={}"

      # @return true
      def leaf?
        true
      end

      def component?
        @usage.component?
      end

      def simple?
        not @usage.component?
      end
    end

  end
end

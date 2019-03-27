# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Values
    #
    # @abstract This must be subclassed to add type- and version-specific
    #   functionality. For instance, DateVal adds `#day`, `#month`, etc.
    #
    # @see X222 B.1.1.3.1 Data Element
    #
    class SimpleElementVal < AbstractElementVal
      # @return [SimpleElementDef]
      def_delegators :usage, :definition, :descriptor

      abstract :valid?

      # @return [String]
      abstract :to_x12

      abstract :too_long?

      abstract :too_short?

      abstract :to_s

      # @return [SimpleElementUse, ComponentElementUse]
      attr_reader :usage

      # @return [Reader::Position]
      attr_reader :position

      def initialize(usage, position)
        @usage, @position =
          usage, position
      end

      # @return [SimpleElementVal]
      abstract :copy, "changes={}"

      # True unless this value isn't included in {Schema::SimpleElementUse#allowed_values}
      def allowed?
        empty? or invalid? or usage.allowed_values.include?(to_s)
      end

      def id?
        false
      end

      def date?
        false
      end

      def time?
        false
      end

      def string?
        false
      end

      def numeric?
        false
      end

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

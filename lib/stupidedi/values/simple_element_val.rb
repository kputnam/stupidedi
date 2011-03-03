module Stupidedi
  module Values

    # @see X222 B.1.1.3.1 Data Element
    class SimpleElementVal < AbstractVal
      attr_reader :element_def
      alias_method :definition, :segment_def

      def initialize(element_def)
        @element_def = element_def
      end

      # @private
      def repeated
        RepeatedElementVal.new([self], element_def)
      end

      def present?
        not empty?
      end
    end

  end
end

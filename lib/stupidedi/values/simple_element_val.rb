module Stupidedi
  module Values

    #
    # This is an abstract class that serves as a common parent to {StringVal},
    # {IdentifierVal}, {DateVal}, {DecimalVal}, {TimeVal}, and {NumericVal}.
    #
    class SimpleElementVal
      attr_reader :element_def
      alias_method :definition, :segment_def

      def initialize(element_def)
        @element_def = element_def
      end

      # Construct a RepeatedElementVal with this element as its sole element.
      #
      # @note Intended for use by {SegmentReader}
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

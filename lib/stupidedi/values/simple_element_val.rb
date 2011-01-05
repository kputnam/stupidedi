module Stupidedi
  module Values

    #
    # This is an abstract class that serves as a common parent to StringVal,
    # IdentifierVal, DateVal, DecimalVal, TimeVal, and NumericVal.
    #
    class SimpleElementVal
      attr_reader :element_def

      def initialize(element_def)
        @element_def = element_def
      end

      ##
      # Construct a RepeatedElementVal with this element as its sole element.
      # NOTE: Intended for use by SegmentReader
      def repeated
        RepeatedElementVal.new([self], element_def)
      end
    end

  end
end

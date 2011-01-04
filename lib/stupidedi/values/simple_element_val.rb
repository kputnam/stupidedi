module Stupidedi
  module Values

    #
    # This is an abstract class that serves as a common parent to String,
    # Identifier, Date, Decimal, Time, and Numeric in the Values namespace
    #
    class SimpleElementVal
      attr_reader :element_def

      def initialize(element_def)
        @element_def = element_def
      end

      # Convert a single instance to a repeated element with this value as
      # its sole element. This is used as a RepeatedElementVal constructor
      # in the ElementReader implementations.
      def repeated
        RepeatedElementVal.new([self], element_def)
      end
    end

  end
end

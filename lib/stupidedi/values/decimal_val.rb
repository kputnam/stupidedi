module Stupidedi
  module Values

    #
    # Mostly an alias of Numeric.
    #
    class DecimalVal < SimpleElementVal
      PATTERN = /\A[+-]?            (?# optional leading sign             )
                 (?:
                   (?:\d+\.?\d*)  | (?# whole with optional decimal or ...)
                   (?:\d*?\.?\d+) ) (?# optional whole with decimal       )
                 (?:E[+-]?\d+)?     (?# optional exponent                 )
                \Z/ix
    end

    #
    # Constructors
    #
    class << DecimalVal
      # Create an empty decimal value.
      #
      # @return [NumericVal::Empty]
      def empty(element_def = nil)
        NumericVal.empty(element_def)
      end

      # Intended for use by ElementReader.
      #
      # @return [NumericVal::NonEmpty]
      # @return [NumericVal::Empty]
      def value(string, element_def = nil)
        if string !~ /\S/
          return NumericVal.empty(element_def)
        end

        if string =~ DecimalVal::PATTERN
          NumericVal::NonEmpty.new(BigDecimal.new(string), element_def)
        else
          raise ArgumentError, "Not a valid decimal #{string.inspect}"
        end
      end

      # Convert a ruby Numeric value (BigDecimal, Integer, Float, Double, etc).
      #
      # @return [NumericVal::NonEmpty]
      def from_numeric(numeric, element_def = nil)
        value(numeric.to_s, element_def)
      end
    end

    # Prevent direct instantiation of abstract class DecimalVal
    DecimalVal.eigenclass.send(:protected, :new)

  end
end

module Stupidedi
  module Values

    #
    # Mostly an alias of Numeric
    #
    class DecimalVal < SimpleElementVal
      PATTERN = /\A[+-]?            (?# optional leading sign             )
                 (?:
                   (?:\d+\.?\d*)  | (?# whole with optional decimal or ...)
                   (?:\d*?\.?\d+) ) (?# optional whole with decimal       )
                 (?:E[+-]?\d+)?     (?# optional exponent                 )
                \Z/ix
    end

    # Constructors
    class << DecimalVal
      def empty(element_def = nil)
        NumericVal.empty(element_def)
      end

      def value(string, element_def)
        if string =~ DecimalVal::PATTERN
          NumericVal::NonEmpty.new(BigDecimal.new(string), element_def)
        else
          raise ArgumentError, "Not a valid decimal #{string.inspect}"
        end
      end

      def from_numeric(numeric, element_def = nil)
        # TODO
        raise NoMethodError, "Not yet implemented"
      end
    end

    # Prevent direct instantiation of abstract class DecimalVal
    DecimalVal.eigenclass.send(:protected, :new)

  end
end

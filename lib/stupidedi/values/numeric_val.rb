module Stupidedi
  module Values

    class NumericVal < SimpleElementVal

      #
      # Empty numeric value. Shouldn't be directly instantiated -- instead,
      # use the NumericVal.value and NumericVal.empty constructors.
      #
      class Empty < NumericVal
        def empty?
          true
        end

        def present?
          false
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "NumericVal.empty#{def_id}"
        end

        def ==(other)
          other.is_a?(self.class)
        end
      end

      #
      # Non-empty numeric value. Shouldn't be directly instantiated -- instead,
      # use the NumericVal.value and NumericVal.from_numeric constructors.
      #
      class NonEmpty < NumericVal
        include Comparable

        attr_reader :delegate

        def initialize(delegate, element_def)
          @delegate = delegate
          super(element_def)
        end

        def inspect
          def_id = element_def.try{|d| "[#{d.id}]" }
          "NumericVal.value#{def_id}(#{delegate.to_s('F')})"
        end

        def empty?
          false
        end

        def present?
          true
        end

        def to_s(*args)
          delegate.to_s(*args)
        end

        def coerce(other)
          case other
          when ::Numeric
            return self, other
          else
            return other, self
          end
        end

        def /(other)
          if other.is_a?(self.class)
            self.class.new(delegate / other.delegate, element_def)
          else
            self.class.new(delegate / other, element_def)
          end
        end

        def +(other)
          if other.is_a?(self.class)
            self.class.new(delegate + other.delegate, element_def)
          else
            self.class.new(delegate + other, element_def)
          end
        end

        def -(other)
          if other.is_a?(self.class)
            self.class.new(delegate - other.delegate, element_def)
          else
            self.class.new(delegate - other, element_def)
          end
        end

        def **(other)
          if other.is_a?(self.class)
            self.class.new(delegate ** other.delegate, element_def)
          else
            self.class.new(delegate ** other, element_def)
          end
        end

        def *(other)
          if other.is_a?(self.class)
            self.class.new(delegate * other.delegate, element_def)
          else
            self.class.new(delegate * other, element_def)
          end
        end

        def %(other)
          if other.is_a?(self.class)
            self.class.new(delegate % other.delegate, element_def)
          else
            self.class.new(delegate % other, element_def)
          end
        end

        def <=>(other)
          if other.is_a?(self.class)
            delegate <=> other.delegate
          else
            delegate <=> other
          end
        end
      end

    end

    #
    # Constructors
    #
    class << NumericVal
      ##
      # Create an empty numeric value.
      def empty(element_def = nil)
        NumericVal::Empty.new(element_def)
      end

      # Intended for use by ElementReader.
      def value(string, element_def)
        if string =~ /^[+-]?\d+$/
          NumericVal::NonEmpty.new(BigDecimal.new(string), element_def)
        else
          raise ArgumentError, "Not a valid numeric #{string.inspect}"
        end
      end

      # Convert a ruby Numeric value.
      def from_numeric(numeric, element_def = nil)
        NumericVal::NonEmpty.new(BigDecimal.new(numeric.to_s), element_def)
      end
    end

    # Prevent direct instantiation of abstract class NumericVal
    NumericVal.eigenclass.send(:protected, :new)
    NumericVal::Empty.eigenclass.send(:public, :new)
    NumericVal::NonEmpty.eigenclass.send(:public, :new)

  end
end

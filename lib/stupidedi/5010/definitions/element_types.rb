module Stupidedi
  module FiftyTen
    module Definitions
      module ElementTypes

        #
        # Numeric element definition. This is abstracted over the number of
        # implied digits to the right of the decimal point.
        #
        # @see Values::NumericVal
        #
        # @abstract
        #
        class Nn < SimpleElementDef
        end

        class << Nn
          # Parses the +string+ assuming {positions} digits are to the right of
          # an implied decimal point. Validates the format of +string+ according
          # to the X12 specification, and returns a failure on invalid input.
          #
          # @param [String] string
          #
          # @return [Either::Success<Values::NumericVal>,
          #          Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string).strip

            if filtered !~ /[^ ]/
              success(Values::NumericVal.empty(instance))
            elsif filtered =~ /^[+-]?\d*$/
              success(Values::NumericVal.value(filtered, instance) / (10 ** positions))
            else
              failure("Not a valid numeric #{string.inspect}")
            end
          end

          # Creates an empty numeric value
          #
          # @return [Values::NumericVal::Empty]
          def empty(instance = nil)
            Values::NumericVal.empty(instance)
          end

          # Subclasses declare the number of implied decimal places by
          # implementing this method
          #
          # @abstract
          #
          # @return [Integer]
          def positions
            raise NoMethodError, "#{self.class} must implement positions"
          end
        end

        # An alias for {N0}
        class N < Nn; end; N.eigenclass.send(:define_method, :positions) { 0 }

        # Numeric with 0 implied decimal places. The number 12 is interpreted
        # and written as "12"
        class N0 < Nn; end; N0.eigenclass.send(:define_method, :positions) { 0 }

        # Numeric with 1 implied decimal place. The number 1.2 is interpreted
        # and written as "12"
        class N1 < Nn; end; N1.eigenclass.send(:define_method, :positions) { 1 }

        # Numeric with 2 implied decimal places. The number 1.23 is interpreted
        # and written as "123"
        class N2 < Nn; end; N2.eigenclass.send(:define_method, :positions) { 2 }

        # Numeric with 3 implied decimal places. The number 1.234 is interpreted
        # and written as "1234"
        class N3 < Nn; end; N3.eigenclass.send(:define_method, :positions) { 3 }

        # Numeric with 4 implied decimal places. The number 1.2345 is
        # interpreted and written as "12345"
        class N4 < Nn; end; N4.eigenclass.send(:define_method, :positions) { 4 }

        # Numeric with 5 implied decimal places. The number 1.23456 is
        # interpreted and written as "123456"
        class N5 < Nn; end; N5.eigenclass.send(:define_method, :positions) { 5 }

        # Numeric with 6 implied decimal places. The number 1.234567 is
        # interpreted and written as "1234567"
        class N6 < Nn; end; N6.eigenclass.send(:define_method, :positions) { 6 }

        # Numeric with 7 implied decimal places. The number 1.2345678 is
        # interpreted and written as "12345678"
        class N7 < Nn; end; N7.eigenclass.send(:define_method, :positions) { 7 }

        # Numeric with 8 implied decimal places. The number 1.23456789 is
        # interpreted and written as "123456789"
        class N8 < Nn; end; N8.eigenclass.send(:define_method, :positions) { 8 }

        # Numeric with 9 implied decimal places
        class N9 < Nn; end; N9.eigenclass.send(:define_method, :positions) { 9 }

        #
        # Decimal element definition
        #
        # @see Values::DecimalVal
        #
        class R < SimpleElementDef
        end

        class << R
          # Parses the given +string+. Delegates the validation to
          # {Values::DecimalVal.value} and returns a failure on invalid input
          #
          # @note While it seems odd to delegate the input validation instead of
          #   implementing it in the version-specific definition, the actual
          #   validation is basically anything that BigDecimal parses correctly
          #   -- which is the underlying representation used by DecimalVal.
          #
          # @param [String] string
          #
          # @return [Either::Success<Values::DecimalVal>,
          #          Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string).strip

            if filtered =~ /^ *$/
              success(Values::DecimalVal.empty(instance))
            else
              begin
                success(Values::DecimalVal.value(filtered, instance))
              rescue ArgumentError
                failure("Not a valid decimal #{string.inspect}")
              end
            end
          end

          # Creates an empty decimal value
          #
          # @return [Values::DecimalVal::Empty]
          def empty(instance = nil)
            Values::DecimalVal.empty(instance)
          end
        end

        #
        # Identifier element definition
        #
        # @see Values::IdentifierVal
        #
        class ID < SimpleElementDef
        end

        class << ID
          # Parses the given +string+, which always succeeds since no validation
          # is performed. Trailing whitespace is stripped, but leading
          # whitespace is preserved according to the X12 specification.
          #
          # @param [String] string
          #
          # @return [Either::Success<Values::IdentifierVal>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string)

            if filtered !~ /[^ ]/
              success(Values::IdentifierVal.empty(instance))
            else
              success(Values::IdentifierVal.value(filtered.rstrip, instance))
            end
          end

          # Creates an empty identifier value.
          #
          # @return [Values::IdentifierVal::Empty]
          def empty(instance = nil)
            Values::IdentifierVal.empty(instance)
          end
        end

        #
        # String element definition
        #
        # @see Values::StringVal
        #
        class AN < SimpleElementDef
        end

        class << AN
          # Parses the given +string+, which always succeeds since no validation
          # is performed. Trailing whitespace is stripped, but leading
          # whitespace is preserved according to the X12 specification.
          #
          # @param [String] string
          #
          # @return [Either::Success<Values::StringVal>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string)

            if filtered !~ /[^ ]/
              # The string element must contain at least one non-space character
              success(Values::StringVal.empty(instance))
            else
              success(Values::StringVal.value(filtered.rstrip, instance))
            end
          end

          # @return [Values::StringVal::Empty]
          def empty(instance = nil)
            Values::StringVal.empty(instance)
          end
        end

        #
        # Date element definition
        #
        # @see Values::DateVal
        #
        class DT < SimpleElementDef
          def initialize(*args)
            super(*args)

            unless min_length == max_length
              raise ArgumentError, "Minimum and maximum length must be equal"
            end

            unless min_length == 6 or min_length == 8
              raise ArgumentError,
                "Minimum and maximum length must either be 6 or 8"
            end
          end
        end

        class << DT
          # Parses the given +string+, *without* respect to the declared length
          # given by the element definition. When the +string+ is eight digits,
          # the format is assumed to be "CCYYMMDD". When the +string+ is six
          # digits, the format is assumed to be "YYMMDD".
          #
          # The input validation is delegated to {Values::DateVal.value} to
          # ensure the date is valid.
          #
          # @param [String] string
          #
          # @return [Either::Success<Values::DateVal>, Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string)

            if filtered !~ /[^ ]/
              Either.success(Values::DateVal.empty(instance))
            else
              # Ignore whitespace
              filtered = filtered.gsub(/ */, "")

              if filtered =~ /^\d{6}$/
                # Two-digit year
                year  = filtered.slice(0, 2)
                month = filtered.slice(2, 2)
                day   = filtered.slice(4, 2)
              elsif filtered =~ /^\d{8}$/
                # Four-digit year
                year  = filtered.slice(0, 4)
                month = filtered.slice(4, 2)
                day   = filtered.slice(6, 2)
              else
                return failure("Expected either 6 or 8 numeric characters for date #{string.inspect}")
              end

              begin
                success(Values::DateVal.value(year, month, day, instance))
              rescue ArgumentError
                failure("Not a valid date '#{year}-#{month}-#{day}' from input #{string.inspect}")
              end
            end
          end

          # Creates an empty date value.
          #
          # @return [Values::DateVal::Empty]
          def empty(instance = nil)
            Values::DateVal.empty(instance)
          end
        end

        #
        # Time element definition
        #
        # @see Values::TimeVal
        #
        class TM < SimpleElementDef
        end

        class << TM
          # Parses the given +string+, and if it consists only of two or more
          # numeric characters, delegates further validation to
          # #{Values::TimeVal.value}.
          #
          # @param [String] string
          #
          # @return [Either::Success<Values::TimeVal>, Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string)

            if filtered =~ /^ *$/
              success(Values::TimeVal.empty(instance))
            else
              # Ignore whitespace
              filtered = filtered.gsub(/ */, "")

              if filtered =~ /^(?:\d{2}|\d{4}|\d{6,})$/
                hour    = filtered.slice(0, 2)
                minute  = filtered.slice(2, 2)
                second  = filtered.slice(4..-1)

                begin
                  success(Values::TimeVal.value(hour, minute, second, instance))
                rescue ArgumentError
                  failure("Not a valid time '#{hour}:#{minute}:#{second}' from input #{string.inspect}")
                end
              else
                failure("Expected numeric characters for time #{string.inspect}")
              end
            end
          end

          # @return [Values::TimeVal::Empty]
          def empty(instance = nil)
            Values::TimeVal.empty(instance)
          end
        end

      end
    end
  end
end

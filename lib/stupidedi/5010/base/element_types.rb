module Stupidedi
  module FiftyTen
    module Base
      module ElementTypes

        #
        # Numeric element definition
        # @see Values::NumericVal
        # @abstract
        #
        class Nn < SimpleElementDef
        end

        class << Nn
          # @return [Either::Success<Values::NumericVal>, Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string).strip

            if filtered !~ /[^ ]/
              success(Values::NumericVal.empty(instance))
            elsif filtered =~ /^[+-]?\d*$/
              success(Values::NumericVal.value(filtered, instance) / (10 ** positions))
            else
              failure("Not a valid numeric (Nn) #{string.inspect}")
            end
          end

          # @return [Values::NumericVal::Empty]
          def empty(instance = nil)
            Values::NumericVal.empty(instance)
          end

          # @abstract
          # @return [Integer]
          def positions
            raise NoMethodError, "#{self.class} must implement positions"
          end
        end

        class N  < Nn; end; class << N ; def positions; 0; end end
        class N0 < Nn; end; class << N0; def positions; 0; end end
        class N1 < Nn; end; class << N1; def positions; 1; end end
        class N2 < Nn; end; class << N2; def positions; 2; end end
        class N3 < Nn; end; class << N3; def positions; 3; end end
        class N4 < Nn; end; class << N4; def positions; 4; end end
        class N5 < Nn; end; class << N5; def positions; 5; end end
        class N6 < Nn; end; class << N6; def positions; 6; end end
        class N7 < Nn; end; class << N7; def positions; 7; end end
        class N8 < Nn; end; class << N8; def positions; 8; end end
        class N9 < Nn; end; class << N9; def positions; 9; end end

        #
        # Decimal element definition
        # @see Values::DecimalVal
        #
        class R < SimpleElementDef
        end

        class << R
          # @return [Either::Success<Values::DecimalVal>, Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string).strip

            if filtered =~ /^ *$/
              success(Values::DecimalVal.empty(instance))
            else
              begin
                success(Values::DecimalVal.value(filtered, instance))
              rescue ArgumentError
                failure("Not a valid decimal (R) #{string.inspect}")
              end
            end
          end

          # @return [Values::DecimalVal::Empty]
          def empty(instance = nil)
            Values::DecimalVal.empty(instance)
          end
        end

        #
        # Identifier element definition
        # @see Values::IdentifierVal
        #
        class ID < SimpleElementDef
        end

        class << ID
          # @return [Either::Success<Values::IdentifierVal>, Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string)

            if filtered !~ /[^ ]/
              success(Values::IdentifierVal.empty(instance))
            else
              # Trailing spaces must be supressed unless they are necessary to satisfy a minimum
              # length requirement. An identifier is always left justified.
              success(Values::IdentifierVal.value(filtered.rstrip, instance))
            end
          end

          # @return [Values::IdentifierVal::Empty]
          def empty(instance = nil)
            Values::IdentifierVal.empty(instance)
          end
        end

        #
        # String element definition
        # @see Values::StringVal
        #
        class AN < SimpleElementDef
        end

        class << AN
          # @return [Either::Success<Values::StringVal>, Either::Failure<String>]
          def parse(string, instance = nil)
            filtered = Reader.strip(string)

            if filtered !~ /[^ ]/
              # The string element must contain at least one non-space character
              success(Values::StringVal.empty(instance))
            else
              # The significant characters shall be left justified. Leading spaces, when they occur,
              # are presumed to be significant characters. Trailing spaces must be supressed unless
              # they are necessary to satisfy a minimum length.
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
        # @see Values::DateVal
        #
        class DT < SimpleElementDef
          def initialize(*args)
            super(*args)

            unless min_length == max_length
              raise ArgumentError, "Minimum length (#{min_length}) and maximum length (#{max_length}) must be equal"
            end

            unless min_length == 6 or min_length == 8
              raise ArgumentError, "Minimum/maximum length (#{min_length}) must be either 6 or 8"
            end
          end
        end

        class << DT
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
                return failure("Expected either 6 or 8 numeric characters for date (DT) #{string.inspect}")
              end

              begin
                success(Values::DateVal.value(year, month, day, instance))
              rescue ArgumentError
                failure("Not a valid year(#{year}) month(#{month}) day(#{day}) for date (DT) #{string.inspect}")
              end
            end
          end

          # @returns [Values::DateVal::Empty]
          def empty(instance = nil)
            Values::DateVal.empty(instance)
          end
        end

        #
        # Time element definition
        # @see Values::TimeVal
        #
        class TM < SimpleElementDef
        end

        class << TM
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
                  failure("Not a valid hour(#{hour}) minute(#{minute}) second(#{second}) for time (TM) #{string.inspect}")
                end
              else
                failure("Expected numeric characters for time (TM) #{string.inspect}")
              end
            end
          end

          # @returns [Values::TimeVal::Empty]
          def empty(instance = nil)
            Values::TimeVal.empty(instance)
          end
        end

      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FortyTen
        module ElementTypes

          #
          class R < SimpleElementDef

            # @return [Integer]
            attr_reader :max_precision

            def initialize(id, name, min_length, max_length, max_precision = nil, description = nil, parent = nil)
              super(id, name, min_length, max_length, description, parent)

              if max_precision.try(:>, max_length)
                raise ArgumentError,
                  "max_precision cannot be greater than max_length"
              end

              @max_precision = max_precision
            end

            def companion
              FloatVal
            end
          end

          #
          # @see X222.pdf B.1.1.3.1.2 Decimal
          #
          class FloatVal < Values::SimpleElementVal
          # PATTERN = /\A[+-]?            (?# optional leading sign            )
          #            (?:
          #              (?:\d+\.?\d*)  | (?# whole with optional decimal or ..)
          #              (?:\d*?\.?\d+) ) (?# optional whole with decimal      )
          #            (?:E[+-]?\d+)?     (?# optional exponent                )
          #           \Z/ix

            def numeric?
              true
            end

            def too_long?
              false
            end

            def too_short?
              false
            end

            class Invalid < FloatVal

              # @return [Object]
              attr_reader :value

              def initialize(value, usage, position)
                @value = value
                super(usage, position)
              end

              def valid?
                false
              end

              def empty?
                false
              end

              # @return [FloatVal]
              def map
                FloatVal.value(yield(nil), usage, position)
              end

              # @return [String]
              def inspect
                id = definition.try do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element(" R.invalid#{id}") << "(#{ansi.invalid(@value.inspect)})"
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [String]
              def to_x12(truncate = true)
                ""
              end

              # @return [Boolean]
              def ==(other)
                eql?(other)
              end
            end

            #
            # Empty numeric value. Shouldn't be directly instantiated -- instead
            # use the {FloatVal.value} and {FloatVal.empty} constructors.
            #
            class Empty < FloatVal

              def valid?
                true
              end

              def empty?
                true
              end

              # @return [FloatVal]
              def map
                FloatVal.value(yield(nil), usage, position)
              end

              # @return [String]
              def inspect
                id = definition.try do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element(" R.empty#{id}")
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [String]
              def to_x12(truncate = true)
                ""
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty) or other.nil?
              end
            end

            #
            # Non-empty numeric value. Shouldn't be directly instantiated --
            # instead, use the {FloatVal.value} constructors.
            #
            class NonEmpty < FloatVal
              include Comparable

              # @group Mathematical Operators
              #################################################################

              extend Operators::Binary
              binary_operators(:+, :-, :*, :/, :%, :coerce => :to_d)

              extend Operators::Relational
              relational_operators(:==, :<=>, :coerce => :to_d)

              extend Operators::Unary
              unary_operators(:abs, :-@, :+@)

              # @endgroup
              #################################################################

              # @return [BigDecimal]
              attr_reader :value
              
              def_delegators :@value, :to_i, :to_d, :to_f, :to_r, :to_c
                 
              
              def initialize(value, usage, position)
                @value = value
                super(usage, position)
              end

              # @return [NonEmpty]
              def copy(changes = {})
                NonEmpty.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:usage, usage),
                  changes.fetch(:position, position)
              end

              def coerce(other)
                # self', other' = other.coerce(self)
                # self' * other'
                return copy(:value => other.to_d), self
              end

              def valid?
                # False for NaN and +/- Infinity
                @value.finite?
              end

              def empty?
                false
              end

              # @return [String]
              def inspect
                id = definition.try do |d|
                  "[#{'% 5s' % d.id}: #{d.name}]".bind do |s|
                    if usage.forbidden?
                      ansi.forbidden(s)
                    elsif usage.required?
                      ansi.required(s)
                    else
                      ansi.optional(s)
                    end
                  end
                end

                ansi.element(" R.value#{id}") << "(#{to_s})"
              end

              # @return [String]
              def to_s
                if definition.max_precision.present?
                  @value.round(definition.max_precision).to_s("F")
                else
                  @value.to_s("F")
                end
              end

              # While the ASC X12 standard supports the usage of exponential
              # notation, the HIPAA guides prohibit it. In the interest of
              # simplicity, this method will not output exponential notation,
              # as there is currently no configuration attribute to indicate
              # if this is allowed or not -- if this is required in the future,
              # the best place for it to fit would be in SimpleElementUse
              #
              # @return [String]
              def to_x12(truncate = true)
                remaining =
                  if @value.to_i.zero?
                    definition.max_length
                  else
                    definition.max_length - @value.to_i.abs.to_s.length
                  end

                if remaining <= 0
                  if truncate
                    int   = @value.to_i.to_s
                    sign  = (int < 0) ? "-" : ""
                    return sign << int.abs.to_s.take(definition.max_length)
                  else
                    return @value.to_i.abs
                  end
                end

                # Don't exceed the definition's max_precision
                precision =
                  if definition.max_precision.present?
                    (definition.max_precision < remaining) ?
                      definition.max_precision : remaining
                  else
                    remaining
                  end

                rounded = @value.round(precision)
                sign    = (rounded < 0) ? "-" : ""

                # Leading zeros preceeding the decimal point and trailing zeros
                # following the decimal point must be supressed unless necessary
                # to satisfy a minimum length requirement or to indicate
                # precision, respectively.
                if rounded.zero?
                  "0" * definition.min_length
                else
                  sign << rounded.abs.to_s("F").
                    gsub(/^0+/, ""). # leading zeros
                    gsub(/0+$/, ""). # trailing zeros
                    gsub(/\.$/, ""). # trailing decimal point
                    rjust(definition.min_length, "0")
                end
              end

              def too_long?
                # We can truncate the fractional portion as much as needed, so
                # the only concern we have about length is regarding the digits
                # to the left of the decimal place.

                # The length of a decimal type does not include an optional sign
                definition.max_length < @value.to_i.abs.to_s.length
              end

              # @return [FloatVal]
              def map
                FloatVal.value(yield(@value), usage, position)
              end
            end

          end

          class << FloatVal
            # @group Constructors
            ###################################################################

            # @return [FloatVal]
            def empty(usage, position)
              self::Empty.new(usage, position)
            end

            # @return [FloatVal]
            def value(object, usage, position)
              if object.blank?
                self::Empty.new(usage, position)
              else
                self::NonEmpty.new(object.to_d, usage, position)
              end
            rescue
              self::Invalid.new(object, usage, position)
            end

            # @endgroup
            ###################################################################
          end

          # Prevent direct instantiation of abstract class FloatVal
          FloatVal.eigenclass.send(:protected, :new)
          FloatVal::Empty.eigenclass.send(:public, :new)
          FloatVal::Invalid.eigenclass.send(:public, :new)
          FloatVal::NonEmpty.eigenclass.send(:public, :new)

        end
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Common
      module ElementTypes
        class R < SimpleElementDef
          # @return [Integer]
          attr_reader :max_precision

          def initialize(id, name, min_length, max_length, max_precision = nil, description = nil, parent = nil)
            super(id, name, min_length, max_length, description, parent)

            if max_precision.try(:>, max_length)
              raise Exceptions::InvalidSchemaError,
                "max_precision cannot be greater than max_length"
            end

            @max_precision = max_precision
          end

          # @return [R]
          def copy(changes = {})
            R.new \
              changes.fetch(:id, @id),
              changes.fetch(:name, @name),
              changes.fetch(:min_length, @min_length),
              changes.fetch(:max_length, @max_length),
              changes.fetch(:max_precision, @max_precision),
              changes.fetch(:description, @description),
              changes.fetch(:parent, @parent)
          end

          def companion
            FloatVal
          end
        end

        #
        # @see X222.pdf B.1.1.3.1.2 Decimal
        #
        class FloatVal < Values::SimpleElementVal
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
              self
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.try do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element(" R.invalid#{id}") + "(#{ansi.invalid(@value.inspect)})"
            end
            # :nocov:

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

            # @return [Invalid]
            def copy(changes = {})
              self
            end
          end

          class Valid < FloatVal
            def valid?
              true
            end

            def coerce(other)
              return FloatVal.value(other, usage, position), self
            end

            # @return [Empty]
            def copy(changes = {})
              FloatVal.value \
                changes.fetch(:value, value),
                changes.fetch(:usage, usage),
                changes.fetch(:position, position)
            end

            # @return [FloatVal]
            def map
              FloatVal.value(yield(value), usage, position)
            end

            # @return [Boolean]
            def ==(other)
              other = FloatVal.value(other, usage, position)
              other.valid? and other.value == value
            end
          end

          class Empty < Valid
            def value
              nil
            end

            def empty?
              true
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.try do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
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
            # :nocov:

            # @return [String]
            def to_s
              ""
            end

            # @return [String]
            def to_x12(truncate = true)
              ""
            end
          end

          class NonEmpty < Valid
            # @group Mathematical Operators
            #################################################################

            extend Operators::Binary
            binary_operators :+, :-, :*, :/, :%, :coerce => :to_d

            extend Operators::Unary
            unary_operators :abs, :-@, :+@

            extend Operators::Relational
            relational_operators :<, :>, :<=, :>=, :<=>, :coerce => :to_d

            # @endgroup
            #################################################################

            # @return [BigDecimal]
            attr_reader :value

            def_delegators :value, :to_i, :to_d, :to_f, :to_r, :to_c

            def initialize(value, usage, position)
              @value = value
              super(usage, position)
            end

            def empty?
              false
            end

            # @return [String]
            # :nocov:
            def inspect
              id = definition.try do |d|
                "[#{"% 5s" % d.id}: #{d.name}]".bind do |s|
                  if usage.forbidden?
                    ansi.forbidden(s)
                  elsif usage.required?
                    ansi.required(s)
                  else
                    ansi.optional(s)
                  end
                end
              end

              ansi.element(" R.value#{id}") + "(#{to_s})"
            end
            # :nocov:

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

              # The integer part consumes all the space, so there is no room
              # for a fractional amount
              if remaining <= 0 and truncate
                int   = @value.to_i
                sign  = (int < 0) ? "-" : ""
                return sign + int.abs.to_s.take(definition.max_length)
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
                base = rounded.abs
                base = base.is_a?(BigDecimal) ? base : BigDecimal(base) 
                sign + base.to_s("F").
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
            if object.is_a?(FloatVal)
              object#.copy(:usage => usage, :position => position)
            elsif object.blank?
              self::Empty.new(usage, position)
            else
              self::NonEmpty.new(object.to_d, usage, position)
            end
          rescue ArgumentError
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

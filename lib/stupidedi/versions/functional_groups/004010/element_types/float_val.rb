module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module ElementTypes

          #
          class R < SimpleElementDef
            def companion
              FloatVal
            end
          end

          #
          # @see X222.pdf A.1.3.1.2 Decimal
          #
          class FloatVal < Values::SimpleElementVal
          # PATTERN = /\A[+-]?            (?# optional leading sign            )
          #            (?:
          #              (?:\d+\.?\d*)  | (?# whole with optional decimal or ..)
          #              (?:\d*?\.?\d+) ) (?# optional whole with decimal      )
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

            #
            #
            #
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

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                  (other.is_a?(Invalid) and @value == other.value)
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

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
              end
            end

            #
            # Non-empty numeric value. Shouldn't be directly instantiated --
            # instead, use the {FloatVal.value} constructors.
            #
            class NonEmpty < FloatVal
              include Comparable

              # @return [BigDecimal]
              attr_reader :value

              delegate :to_i, :to_d, :to_f, :to => :@value

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

              def valid?
                # False for NaN and +/- Infinity
                @value.finite?
              end

              def empty?
                false
              end

              # @return [Array(NonEmpty, Numeric)]
              def coerce(other)
                if other.respond_to?(:to_d)
                  # Re-evaluate other.call(self) as self.op(other.to_d)
                  return self, other.to_d
                else
                  # Fail, other.call(self) is still other.call(self)
                  raise TypeError, "#{other.class} can't be coerced into #{NonEmpty}"
                end
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
                if false #definition.precision.present?
                  @value.round(definition.precision).to_s("F")
                else
                  @value.to_s("F")
                end.gsub(/\.0$/, "")
              end

              # @group Mathematical Operators
              #################################################################

              # @return [NonEmpty]
              def /(other)
                copy(:value => (@value / other).to_d)
              end

              # @return [NonEmpty]
              def +(other)
                copy(:value => (@value + other).to_d)
              end

              # @return [NonEmpty]
              def -(other)
                copy(:value => (@value - other).to_d)
              end

              # @return [NonEmpty]
              def **(other)
                copy(:value => (@value ** other).to_d)
              end

              # @return [NonEmpty]
              def *(other)
                copy(:value => (@value * other).to_d)
              end

              # @return [NonEmpty]
              def %(other)
                copy(:value => (@value % other).to_d)
              end

              # @return [NonEmpty]
              def -@
                copy(:value => -@value)
              end

              # @return [NonEmpty]
              def +@
                self
              end

              # @return [NonEmpty]
              def abs
                copy(:value => @value.abs)
              end

              # @return [-1, 0, +1]
              def <=>(other)
                if other.respond_to?(:value)
                  @value <=> other.value
                else
                  @value <=> other
                end
              end

              # @endgroup
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
              elsif object.respond_to?(:to_d)
                begin
                  self::NonEmpty.new(object.to_d, usage, position)
                rescue ArgumentError
                  self::Invalid.new(object, usage, position)
                end
              else
                self::Invalid.new(object, usage, position)
              end
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

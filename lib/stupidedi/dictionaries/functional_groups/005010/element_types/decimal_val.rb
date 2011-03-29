module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # @see X222.pdf B.1.1.3.1.2 Decimal
          #
          class DecimalVal < Values::SimpleElementVal
            PATTERN = /\A[+-]?            (?# optional leading sign            )
                       (?:
                         (?:\d+\.?\d*)  | (?# whole with optional decimal or ..)
                         (?:\d*?\.?\d+) ) (?# optional whole with decimal      )
                       (?:E[+-]?\d+)?     (?# optional exponent                )
                      \Z/ix

            #
            # Empty numeric value. Shouldn't be directly instantiated -- instead
            # use the {DecimalVal.value} and {DecimalVal.empty} constructors.
            #
            class Empty < DecimalVal
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

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
              end
            end

            #
            # Non-empty numeric value. Shouldn't be directly instantiated --
            # instead, use the {DecimalVal.value} constructors.
            #
            class NonEmpty < DecimalVal
              include Comparable

              # @return [BigDecimal]
              attr_reader :value

              delegate :to_i, :to_d, :to_f, :to_s, :to => :@value

              def initialize(value, usage)
                @value = value
                super(usage)
              end

              # @return [NonEmpty]
              def copy(changes = {})
                NonEmpty.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:usage, usage)
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

                ansi.element(" R.value#{id}") << "(#{@value.to_s('F')})"
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

          class << DecimalVal
            # @group Constructors
            ###################################################################

            # @return [DecimalVal::Empty]
            def empty(usage)
              DecimalVal::Empty.new(usage)
            end

            # @return [DecimalVal::Empty, DecimalVal::NonEmpty]
            def value(object, usage)
              if object.blank?
                DecimalVal::Empty.new(usage)
              elsif object.respond_to?(:to_d)
                DecimalVal::NonEmpty.new(object.to_d, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            # @endgroup
            ###################################################################
          end

          # Prevent direct instantiation of abstract class DecimalVal
          DecimalVal.eigenclass.send(:protected, :new)
          DecimalVal::Empty.eigenclass.send(:public, :new)
          DecimalVal::NonEmpty.eigenclass.send(:public, :new)

        end
      end
    end
  end
end

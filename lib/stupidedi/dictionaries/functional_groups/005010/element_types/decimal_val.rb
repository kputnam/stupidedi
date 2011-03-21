module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

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
                def_id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                " R.empty#{def_id}"
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(self.class)
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

              def initialize(value, definition, parent, usage)
                @value = value
                super(definition, parent, usage)
              end

              def copy(changes = {})
                self.class.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent),
                  changes.fetch(:usage, usage)
              end

              def empty?
                false
              end

              # @return [Array(NonEmpty, Numeric)]
              def coerce(other)
                if other.is_a?(::Numeric)
                  # Re-evaluate other.call(self) as self.op(other)
                  return self, other
                elsif other.is_a?(NumericVal)
                  # Re-evaluate other.call(self) as self.op(other)
                  return self, other.to_d
                else
                  # Fail, other.call(self) is still other.call(self)
                  raise TypeError, "#{other.class} can't be coerced into #{self.class}"
                end
              end

              # @return [String]
              def inspect
                def_id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                " R.value#{def_id}(#{@value.to_s('F')})"
              end

              # @group Mathematical Operators
              #################################################################

              # @return [NonEmpty]
              def /(other)
                if other.is_a?(self.class)
                  copy(:value => @value / other.value)
                else
                  copy(:value => (@value / other).to_d)
                end
              end

              # @return [NonEmpty]
              def +(other)
                if other.is_a?(self.class)
                  copy(:value => @value + other.value)
                else
                  copy(:value => (@value + other).to_d)
                end
              end

              # @return [NonEmpty]
              def -(other)
                if other.is_a?(self.class)
                  copy(:value => @value - other.value)
                else
                  copy(:value => (@value - other).to_d)
                end
              end

              # @return [NonEmpty]
              def **(other)
                if other.is_a?(self.class)
                  copy(:value => @value ** other.value)
                else
                  copy(:value => (@value ** other).to_d)
                end
              end

              # @return [NonEmpty]
              def *(other)
                if other.is_a?(self.class)
                  copy(:value => @value * other.value)
                else
                  copy(:value => (@value * other).to_d)
                end
              end

              # @return [NonEmpty]
              def %(other)
                if other.is_a?(self.class)
                  copy(:value => @value % other.value)
                else
                  copy(:value => (@value % other).to_d)
                end
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
                if other.is_a?(DecimalVal) or other.is_a?(NumericVal)
                  @value <=> other.value
                else
                  @value <=> other
                end
              end

              # @endgroup
            end

          end

          class << DecimalVal
            ###################################################################
            # @group Constructors

            # @return [DecimalVal::Empty]
            def empty(definition, parent, usage)
              DecimalVal::Empty.new(definition, parent, usage)
            end

            # @return [DecimalVal::Empty, DecimalVal::NonEmpty]
            def value(object, definition, parent, usage)
              if object.blank?
                DecimalVal::Empty.new(definition, parent, usage)
              elsif object.respond_to?(:to_d)
                DecimalVal::NonEmpty.new(object.to_d, definition, parent, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            # @return [DecimalVal::Empty, DecimalVal::NonEmpty]
            def parse(string, definition, parent, usage)
              if string.blank?
                DecimalVal::Empty.new(definition, parent, usage)
              else
                DecimalVal::NonEmpty.new(string.to_d, definition, parent, usage)
              end
            rescue ArgumentError
              # @todo
              DecimalVal::Empty.new(definition, parent, usage)
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

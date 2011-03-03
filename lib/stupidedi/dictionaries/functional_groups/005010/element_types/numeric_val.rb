module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class NumericVal < Values::SimpleElementVal

            #
            # Empty numeric value. Shouldn't be directly instantiated -- instead
            # use the {NumericVal.value} and {NumericVal.empty} constructors.
            #
            class Empty < NumericVal
              def empty?
                true
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "NumericVal.empty#{def_id}"
              end

              # @private
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Non-empty numeric value. Shouldn't be directly instantiated --
            # instead, use the {NumericVal.value} constructors.
            #
            class NonEmpty < NumericVal
              include Comparable

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

              # @private
              def coerce(other)
                if other.is_a?(Numeric)
                  # Re-evaluate other.call(self) as self.op(other)
                  return self, other
                else
                  # Fail, other.call(self) is still other.call(self)
                  raise TypeError, "#{other.class} can't be coerced into #{self.class}"
                end
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "NumericVal.value#{def_id}(#{@value.to_s('F')})"
              end

              # @group Mathematical Operators

              # @return [NumericVal::NonEmpty]
              def /(other)
                if other.is_a?(self.class)
                  copy(:value => @value / other.value)
                else
                  copy(:value => (@value / other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def +(other)
                if other.is_a?(self.class)
                  copy(:value => @value + other.value)
                else
                  copy(:value => (@value + other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def -(other)
                if other.is_a?(self.class)
                  copy(:value => @value - other.value)
                else
                  copy(:value => (@value - other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def **(other)
                if other.is_a?(self.class)
                  copy(:value => @value ** other.value)
                else
                  copy(:value => (@value ** other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def *(other)
                if other.is_a?(self.class)
                  copy(:value => @value * other.value)
                else
                  copy(:value => (@value * other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def %(other)
                if other.is_a?(self.class)
                  copy(:value => @value % other.value)
                else
                  copy(:value => (@value % other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def -@
                copy(:value => -@value)
              end

              # @return [NumericVal::NonEmpty]
              def +@
                self
              end

              def abs
                copy(:value => @value.abs)
              end

              # @return [-1, 0, +1]
              def <=>(other)
                if other.is_a?(self.class)
                  @value <=> other.value
                else
                  @value <=> other
                end
              end

              # @endgroup
            end

          end

          class << NumericVal
            # @group Constructors

            # Create an empty numeric value.
            #
            # @return [NumericVal::Empty]
            def empty(definition, parent, usage)
              NumericVal::Empty.new(definition, parent, usage)
            end

            def value(object, definition, parent, usage)
              if object.blank? or object.is_a?(NumericVal::Empty)
                NumericVal::Empty.new(definition, parent, usage)
              elsif object.respond_to?(:to_d)
                NumericVal::NonEmpty.new(object.to_d, definition, parent, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            # @endgroup
          end

          # Prevent direct instantiation of abstract class NumericVal
          NumericVal.eigenclass.send(:protected, :new)
          NumericVal::Empty.eigenclass.send(:public, :new)
          NumericVal::NonEmpty.eigenclass.send(:public, :new)
        end

      end
    end
  end
end

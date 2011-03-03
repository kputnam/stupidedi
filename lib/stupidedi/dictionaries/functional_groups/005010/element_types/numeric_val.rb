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

              attr_reader :delegate

              delegate :to_i, :to_d, :to_f, :to_s, :to => :@delegate

              def initialize(value, definition, parent)
                @delegate = value
                super(definition, parent)
              end

              def copy(changes = {})
                self.class.new \
                  changes.fetch(:delegate, @delegate),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent)
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
                "NumericVal.value#{def_id}(#{@delegate.to_s('F')})"
              end

              # @group Mathematical Operators

              # @return [NumericVal::NonEmpty]
              def /(other)
                if other.is_a?(self.class)
                  copy(:delegate => @delegate / other.delegate)
                else
                  copy(:delegate => (@delegate / other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def +(other)
                if other.is_a?(self.class)
                  copy(:delegate => @delegate + other.delegate)
                else
                  copy(:delegate => (@delegate + other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def -(other)
                if other.is_a?(self.class)
                  copy(:delegate => @delegate - other.delegate)
                else
                  copy(:delegate => (@delegate - other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def **(other)
                if other.is_a?(self.class)
                  copy(:delegate => @delegate ** other.delegate)
                else
                  copy(:delegate => (@delegate ** other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def *(other)
                if other.is_a?(self.class)
                  copy(:delegate => @delegate * other.delegate)
                else
                  copy(:delegate => (@delegate * other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def %(other)
                if other.is_a?(self.class)
                  copy(:delegate => @delegate % other.delegate)
                else
                  copy(:delegate => (@delegate % other).to_d)
                end
              end

              # @return [NumericVal::NonEmpty]
              def -@
                copy(:delegate => -@delegate)
              end

              # @return [NumericVal::NonEmpty]
              def +@
                self
              end

              def abs
                copy(:delegate => @delegate.abs)
              end

              # @return [-1, 0, +1]
              def <=>(other)
                if other.is_a?(self.class)
                  @delegate <=> other.delegate
                else
                  @delegate <=> other
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
            def empty(definition, parent)
              NumericVal::Empty.new(definition, parent)
            end

            def value(object, definition, parent)
              if object.nil? or object.is_a?(NumericVal::Empty)
                NumericVal::Empty.new(definition, parent)
              elsif object.respond_to?(:to_d)
                NumericVal::NonEmpty.new(object.to_d, definition, parent)
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

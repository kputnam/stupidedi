module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class IdentifierVal < Values::SimpleElementVal

            #
            # Empty identifier value. Shouldn't be directly instantiated --
            # instead, use the {IdentifierVal.empty} and {IdentifierVal.value}
            # constructors
            #
            class Empty < IdentifierVal
              def empty?
                true
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "IdentifierVal.empty#{def_id}"
              end

              # @private
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Non-empty identifier value. Shouldn't be directly instantiated --
            # instead, use the {IdentifierVal.value} and
            # {IdentifierVal.from_string} constructors
            #
            class NonEmpty < IdentifierVal
              attr_reader :value

              delegate :to_s, :length, :=~, :match, :include?, :to => :@value

              def initialize(value, definition, parent)
                @value = value
                super(definition, parent)
              end

              def copy(changes = {})
                self.class.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent)
              end

              def empty?
                false
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "IdentifierVal.value#{def_id}(#{@value})"
              end

              # @note Not commutative, because String doesn't call coerce
              # @private
              def ==(other)
                if other.is_a?(self.class)
                  @value == other.value
                else
                  @value == other
                end
              end
            end

          end

          class << IdentifierVal
            # @group Constructors

            # Create an empty identifier value.
            #
            # @return [IdentifierVal::Empty]
            def empty(definition, parent)
              IdentifierVal::Empty.new(definition, parent)
            end

            # @return [IdentifierVal::Empty, IdentifierVal::NonEmpty]
            def value(object, definition, parent)
              if object.nil?
                IdentifierVal::Empty.new(definition, parent)
              elsif object.is_a?(String) or object.is_a?(StringVal) or object.is_a?(IdentifierVal)
                if object.empty?
                  IdentifierVal::Empty.new(definition, parent)
                else
                  IdentifierVal::NonEmpty.new(object.to_s, definition, parent)
                end
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            def reader(input, context)
              raise NoMethodError, "@todo"
            end

            # @endgroup
          end

          # Prevent direct instantiation of abstract class IdentifierVal
          IdentifierVal.eigenclass.send(:protected, :new)
          IdentifierVal::Empty.eigenclass.send(:public, :new)
          IdentifierVal::NonEmpty.eigenclass.send(:public, :new)
        end

      end
    end
  end
end

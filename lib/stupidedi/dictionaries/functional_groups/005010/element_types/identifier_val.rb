module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # @see X222.pdf B.1.1.3.1.3 Identifier
          #
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
                def_id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "ID.empty#{def_id}"
              end

              # @private
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Non-empty identifier value. Shouldn't be directly instantiated --
            # instead, use the {IdentifierVal.value} constructor
            #
            class NonEmpty < IdentifierVal

              # @return [String]
              attr_reader :value

              delegate :to_s, :length, :=~, :match, :include?, :to => :@value

              def initialize(value, definition, parent, usage)
                @value = value
                super(definition, parent, usage)
              end

              # @return [NonEmpty]
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

              # @return [String]
              def inspect
                def_id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "ID.value#{def_id}(#{@value})"
              end

              # @note Not commutative, because String doesn't call coerce
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
            ###################################################################
            # @group Constructors

            # @return [IdentifierVal::Empty]
            def empty(definition, parent, usage)
              IdentifierVal::Empty.new(definition, parent, usage)
            end

            # @return [IdentifierVal::Empty, IdentifierVal::NonEmpty]
            def value(object, definition, parent, usage)
              if object.blank?
                IdentifierVal::Empty.new(definition, parent, usage)
              elsif object.respond_to?(:to_s)
                IdentifierVal::NonEmpty.new(object.to_s, definition, parent, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            # @return [IdentifierVal::Empty, IdentifierVal::NonEmpty]
            def parse(string, definition, parent, usage)
              if string.blank?
                IdentifierVal::Empty.new(definition, parent, usage)
              else
                IdentifierVal::NonEmpty.new(string, definition, parent, usage)
              end
            end

            # @endgroup
            ###################################################################
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

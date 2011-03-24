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

              # @return [String]
              def inspect
                id = definition.try do |d|
                  ansi.bold("[#{'% 5s' % d.id}: #{d.name}]")
                end

                ansi.element("ID.empty#{id}")
              end

              # @return [Boolean]
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

              def initialize(value, definition, usage)
                @value = value
                super(definition, usage)
              end

              # @return [NonEmpty]
              def copy(changes = {})
                self.class.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:definition, definition),
                  changes.fetch(:usage, usage)
              end

              def empty?
                false
              end

              # @return [String]
              def inspect
                id = definition.try do |d|
                  ansi.bold("[#{'% 5s' % d.id}: #{d.name}]")
                end

                ansi.element("ID.value#{id}") << "(#{@value})"
              end

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                 (if other.is_a?(self.class)
                    other.value == @value
                  else
                    other == @value
                  end)
              end
            end

          end

          class << IdentifierVal
            ###################################################################
            # @group Constructors

            # @return [IdentifierVal::Empty]
            def empty(definition, usage)
              IdentifierVal::Empty.new(definition, usage)
            end

            # @return [IdentifierVal::Empty, IdentifierVal::NonEmpty]
            def value(object, definition, usage)
              if object.blank?
                IdentifierVal::Empty.new(definition, usage)
              elsif object.respond_to?(:to_s)
                IdentifierVal::NonEmpty.new(object.to_s, definition, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
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

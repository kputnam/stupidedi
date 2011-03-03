module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class StringVal < Values::SimpleElementVal

            #
            # Empty string value. Shouldn't be directly instantiated -- instead,
            # use the {StringVal.empty} constructor.
            #
            class Empty < StringVal
              def empty?
                true
              end

              # @private
              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "StringVal.empty#{def_id}"
              end

              # @private
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Non-empty string value. Shouldn't be directly instantiated --
            # instead, use the {StringVal.value} constructor.
            #
            class NonEmpty < StringVal
              attr_reader :value

              delegate :to_d, :to_s, :to_f, :length, :to => :@value

              def initialize(string, definition, parent)
                @value = string
                super(definition, parent)
              end

              def copy(changes = {})
                self.class.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent)
              end

              def inspect
                def_id = definition.try{|d| "[#{d.id}]" }
                "StringVal.value#{def_id}(#{@value})"
              end

              def empty?
                false
              end

              # @note Not commutative
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

          class << StringVal
            # @group Constructors

            def empty(definition, parent)
              StringVal::Empty.new(definition, parent)
            end

            def value(object, definition, parent)
              if object.respond_to?(:to_s)
                s = object.to_s

                if s.empty?
                  StringVal::Empty.new(definition, parent)
                else
                  StringVal::NonEmpty.new(s, definition, parent)
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

          # Prevent direct instantiation of abstract class StringVal
          StringVal.eigenclass.send(:protected, :new)
          StringVal::Empty.eigenclass.send(:public, :new)
          StringVal::NonEmpty.eigenclass.send(:public, :new)
        end

      end
    end
  end
end

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
                def_id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "AN.empty#{def_id}"
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(self.class)
              end
            end

            #
            # Non-empty string value. Shouldn't be directly instantiated --
            # instead, use the {StringVal.value} constructor.
            #
            class NonEmpty < StringVal

              # @return [String]
              attr_reader :value

              delegate :to_d, :to_s, :to_f, :length, :to => :@value

              def initialize(string, definition, parent, usage)
                @value = string
                super(definition, parent, usage)
              end

              def copy(changes = {})
                self.class.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:definition, definition),
                  changes.fetch(:parent, parent),
                  changes.fetch(:usage, usage)
              end

              def inspect
                def_id = definition.try{|d| "[#{'% 5s' % d.id}: #{d.name}]" }
                "AN.value#{def_id}(#{@value})"
              end

              def empty?
                false
              end

              # @note Not commutative
              # @return [Boolean]
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

            def empty(definition, parent, usage)
              StringVal::Empty.new(definition, parent, usage)
            end

            def value(object, definition, parent, usage)
              if object.blank?
                StringVal::Empty.new(definition, parent, usage)
              elsif object.respond_to?(:to_s)
                StringVal::NonEmpty.new(object.to_s, definition, parent, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
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

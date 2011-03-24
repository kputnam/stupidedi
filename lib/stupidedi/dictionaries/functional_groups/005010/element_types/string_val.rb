module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          #
          # @see X222.pdf B.1.1.3.1.4 String
          #
          class StringVal < Values::SimpleElementVal

            #
            # Empty string value. Shouldn't be directly instantiated -- instead,
            # use the {StringVal.empty} constructor.
            #
            class Empty < StringVal
              def empty?
                true
              end

              # @return [String]
              def inspect
                id = definition.try do |d|
                  ansi.bold("[#{'% 5s' % d.id}: #{d.name}]")
                end

                ansi.element("AN.empty#{id}")
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
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

              def initialize(string, definition, usage)
                @value = string
                super(definition, usage)
              end

              # @return [NonEmpty]
              def copy(changes = {})
                self.class.new \
                  changes.fetch(:value, @value),
                  changes.fetch(:definition, definition),
                  changes.fetch(:usage, usage)
              end

              # @return [String]
              def inspect
                id = definition.try do |d|
                  ansi.bold("[#{'% 5s' % d.id}: #{d.name}]")
                end

                ansi.element("AN.value#{id}") << "(#{@value})"
              end

              def empty?
                false
              end

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                 (if other.is_a?(NonEmpty)
                    other.value == @value
                  else
                    other == @value
                  end)
              end
            end

          end

          class << StringVal
            ###################################################################
            # @group Constructors

            # @return [StringVal::Empty]
            def empty(definition, usage)
              StringVal::Empty.new(definition, usage)
            end

            # @return [StringVal::Empty, StringVal::NonEmpty]
            def value(object, definition, usage)
              if object.blank?
                StringVal::Empty.new(definition, usage)
              elsif object.respond_to?(:to_s)
                StringVal::NonEmpty.new(object.to_s, definition, usage)
              else
                raise TypeError, "Cannot convert #{object.class} to #{self}"
              end
            end

            # @endgroup
            ###################################################################
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

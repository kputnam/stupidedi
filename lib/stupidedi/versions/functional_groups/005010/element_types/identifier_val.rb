module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class ID < SimpleElementDef

            # @return [Schema::CodeList]
            attr_reader :code_list

            def initialize(id, name, min_length, max_length, code_list = nil, description = nil, parent = nil)
              super(id, name, min_length, max_length, description, parent)
              @code_list = code_list
            end

            def companion
              IdentifierVal
            end

            # @return [ID]
            def copy(changes = {})
              ID.new \
                changes.fetch(:id, @id),
                changes.fetch(:name, @name),
                changes.fetch(:min_length, @min_length),
                changes.fetch(:max_length, @max_length),
                changes.fetch(:code_list, @code_list),
                changes.fetch(:description, @description),
                changes.fetch(:parent, @parent)
            end

            # @return [SimpleElementUse]
            def simple_use(requirement, repeat_count, parent = nil)
              if @code_list and @code_list.internal?
                Schema::SimpleElementUse.new(self, requirement, repeat_count, Sets.absolute(code_list.codes), parent)
              else
                Schema::SimpleElementUse.new(self, requirement, repeat_count, Sets.universal, parent)
              end
            end

            # @return [ComponentElementUse]
            def component_use(requirement, parent = nil)
              if @code_list and @code_list.internal?
                Schema::ComponentElementUse.new(self, requirement, Sets.absolute(code_list.codes), parent)
              else
                Schema::ComponentElementUse.new(self, requirement, Sets.universal, parent)
              end
            end
          end

          #
          # @see X222.pdf B.1.1.3.1.3 Identifier
          #
          class IdentifierVal < Values::SimpleElementVal

            #
            #
            #
            class Invalid < IdentifierVal

              # @return [Object]
              attr_reader :value

              def initialize(value, usage)
                super(usage)
                @value = value
              end

              def valid?
                false
              end

              def empty?
                false
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
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

                ansi.element("ID.invalid#{id}") << "(#{ansi.invalid(@value.inspect)})"
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [Boolean]
              def ==(other)
                eql?(other) or
                  (other.is_a?(Invalid) and @value == other.value)
              end
            end

            #
            # Empty identifier value. Shouldn't be directly instantiated --
            # instead, use the {IdentifierVal.empty} and {IdentifierVal.value}
            # constructors
            #
            class Empty < IdentifierVal

              def valid?
                false
              end

              def empty?
                true
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
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

                ansi.element("ID.empty#{id}")
              end

              # @return [String]
              def to_s
                ""
              end

              # @return [Boolean]
              def ==(other)
                other.is_a?(Empty)
              end
            end

            #
            # Non-empty identifier value. Shouldn't be directly instantiated --
            # instead, use the {IdentifierVal.value} constructor
            #
            class NonEmpty < IdentifierVal

              # @return [String]
              attr_reader :value

              delegate :to_s, :to_str, :length, :=~, :match, :include?, :to => :@value

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

              def valid?
                true
              end

              def empty?
                false
              end

              # @return [String]
              def inspect
                id = definition.bind do |d|
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

                codes = definition.code_list

                if codes.try(&:internal?)
                  if codes.defined_at?(@value)
                    value = "#{@value}: " << ansi.dark(codes.at(@value))
                  else
                    value = ansi.red("#{@value}: " << ansi.bold("Invalid Value"))
                  end
                else
                  value = @value
                end

                ansi.element("ID.value#{id}") << "(#{value})"
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

          class << IdentifierVal
            # @group Constructors
            ###################################################################

            # @return [IdentifierVal]
            def empty(usage)
              IdentifierVal::Empty.new(usage)
            end

            # @return [IdentifierVal]
            def value(object, usage)
              if object.blank?
                IdentifierVal::Empty.new(usage)
              elsif object.respond_to?(:to_s)
                IdentifierVal::NonEmpty.new(object.to_s, usage)
              else
                IdentifierVal::Invalid.new(object, usage)
              end
            end

            # @return [IdentifierVal]
            def parse(string, usage)
              if string.blank?
                IdentifierVal::Empty.new(usage)
              else
                IdentifierVal::NonEmpty.new(string, usage)
              end
            end

            # @endgroup
            ###################################################################
          end

          # Prevent direct instantiation of abstract class IdentifierVal
          IdentifierVal.eigenclass.send(:protected, :new)
          IdentifierVal::Empty.eigenclass.send(:public, :new)
          IdentifierVal::Invalid.eigenclass.send(:public, :new)
          IdentifierVal::NonEmpty.eigenclass.send(:public, :new)
        end

      end
    end
  end
end

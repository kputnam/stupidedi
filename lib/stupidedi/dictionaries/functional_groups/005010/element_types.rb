module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          class SimpleElementDef < Schema::SimpleElementDef

            # @return [Symbol]
            attr_reader :id

            # @return [String]
            attr_reader :name

            # @return [String]
            attr_reader :description

            # @return [Integer]
            attr_reader :min_length

            # @return [Integer]
            attr_reader :max_length

            # @return [Schema::SegmentDef, Schema::CompositeElementDef]
            attr_reader :parent

            # @return [Class<Values::SimpleElementVal>]
            abstract :companion

            def initialize(id, name, min_length, max_length, description = nil, parent = nil)
              @id, @name, @min_length, @max_length, @description, @parent =
                id, name, min_length, max_length, description, parent

              if min_length > max_length
                raise ArgumentError, "Minimum length cannot be greater than maximum length"
              end
            end

            # @return [SimpleElementDef]
            def copy(changes = {})
              self.class.new \
                changes.fetch(:id, @id),
                changes.fetch(:name, @name),
                changes.fetch(:min_length, @min_length),
                changes.fetch(:max_length, @max_length),
                changes.fetch(:description, @description),
                changes.fetch(:parent, @parent)
            end

            # @return [Values::SimpleElementVal]
            def parse(string, usage)
              companion.parse(string, self, usage)
            end

            # @return [Values::SimpleElementVal]
            def value(object, usage)
              companion.value(object, usage)
            end

            # @return [Values::SimpleElementVal]
            def empty(usage)
              companion.empty(usage)
            end

            # @return [void]
            def pretty_print(q)
              type = self.class.name.try{|n| n.split('::').last }

              if type.blank?
                q.text @id.to_s
              else
                q.text "#{type}[#{@id}]"
              end
            end
          end

          autoload :BinaryVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/binary_val"

          class B < SimpleElementDef
            def companion
              BinaryVal
            end
          end

          autoload :DateVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/date_val"

          class DT < SimpleElementDef
            def initialize(id, name, min_length, max_length, description = nil, parent = nil)
              super(id, name, min_length, max_length, description, parent)

              unless min_length == 6 or min_length == 8
                raise ArgumentError,
                  "Minimum length must be either 6 or 8"
              end

              unless max_length == 6 or max_length == 8
                raise ArgumentError,
                  "Maximum length must be either 6 or 8"
              end
            end

            def companion
              DateVal
            end
          end

          autoload :DecimalVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/decimal_val"

          class R < SimpleElementDef
            def companion
              DecimalVal
            end
          end

          autoload :IdentifierVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/identifier_val"

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

          autoload :NumericVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/numeric_val"

          class Nn < SimpleElementDef
            attr_reader :precision

            def initialize(id, name, min_length, max_length, precision, description = nil, parent = nil)
              super(id, name, min_length, max_length, description, parent)

              if precision > max_length
                raise ArgumentError,
                  "Precision cannot be greater than maximum length"
              end

              @precision = precision
            end

            # @return [Nn]
            def copy(changes = {})
              Nn.new \
                changes.fetch(:id, @id),
                changes.fetch(:name, @name),
                changes.fetch(:min_length, @min_length),
                changes.fetch(:max_length, @max_length),
                changes.fetch(:precision, @precision),
                changes.fetch(:description, @description),
                changes.fetch(:parent, @parent)
            end

            # @return [void]
            def pretty_print(q)
              q.text "N#{@precision}[#{@id}]"
            end

            def companion
              NumericVal
            end
          end

          autoload :StringVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/string_val"

          class AN < SimpleElementDef
            def companion
              StringVal
            end
          end

          autoload :TimeVal,
            "stupidedi/dictionaries/functional_groups/005010/element_types/time_val"

          class TM < SimpleElementDef
            def initialize(id, name, min_length, max_length, description = nil, parent = nil)
              super(id, name, min_length, max_length, description)

              unless min_length == 2 or min_length == 4 or min_length >= 6
                raise ArgumentError,
                  "Minimum length must be either 2, 4, 6, or greater"
              end

              unless max_length == 2 or max_length == 4 or max_length >= 6
                raise ArgumentError,
                  "Maximum length must be either 2, 4, 6, or greater"
              end
            end

            def companion
              TimeVal
            end
          end

        end
      end
    end
  end
end

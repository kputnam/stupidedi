module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FortyTen
        module ElementTypes

          class SimpleElementDef < Schema::SimpleElementDef
            attr_reader :id

            attr_reader :name

            attr_reader :purpose

            attr_reader :min_length

            attr_reader :max_length

            def initialize(id, name, purpose, min_length, max_length)
              if min_length > max_length
                raise ArgumentError, "Minimum length cannot be greater than maximum length"
              end

              @id, @name, @purpose, @min_length, @max_length =
                id, name, purpose, min_length, max_length
            end

            def copy(changes = {})
              self.class.new \
                changes.fetch(:id, @id),
                changes.fetch(:name, @name),
                changes.fetch(:purpose, @purpose),
                changes.fetch(:min_length, @min_length),
                changes.fetch(:max_length, @max_length)
            end

            abstract :companion

            def value(object, parent)
              companion.value(object, self, parent)
            end

            def empty(parent)
              companion.empty(self, parent)
            end

            def reader(input, context)
              companion.reader(input, context)
            end
          end

          autoload :BinaryVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/binary_val"

          class B < SimpleElementDef
            def companion
              BinaryVal
            end
          end

          autoload :DateVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/date_val"

          class DT < SimpleElementDef
            def initialize(id, name, purpose, min_length, max_length)
              unless min_length == 6 or min_length == 8
                raise ArgumentError,
                  "Minimum length must be either 6 or 8"
              end

              unless max_length == 6 or max_length == 8
                raise ArgumentError,
                  "Maximum length must be either 6 or 8"
              end

              super(id, name, purpose, min_length, max_length)
            end

            def companion
              DateVal
            end
          end

          autoload :DecimalVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/decimal_val"

          class R < SimpleElementDef
            def companion
              DecimalVal
            end
          end

          autoload :IdentifierVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/identifier_val"

          class ID < SimpleElementDef
            def companion
              IdentifierVal
            end
          end

          autoload :NumericVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/numeric_val"

          class Nn < SimpleElementDef
            attr_reader :precision

            def initialize(id, name, purpose, min_length, max_length, precision)
              if precision > max_length
                raise ArgumentError,
                  "Precision cannot be greater than maximum length"
              end

              super(id, name, purpose, min_length, max_length)
              @precision = precision
            end

            def copy(changes = {})
              self.class.new \
                changes.fetch(:id, @id),
                changes.fetch(:name, @name),
                changes.fetch(:purpose, @purpose),
                changes.fetch(:min_length, @min_length),
                changes.fetch(:max_length, @max_length),
                changes.fetch(:precision, @precision)
            end

            def companion
              NumericVal
            end
          end

          autoload :StringVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/string_val"

          class AN < SimpleElementDef
            def companion
              StringVal
            end
          end

          autoload :TimeVal,
            "stupidedi/dictionaries/functional_groups/004010/element_types/time_val"

          class TM < SimpleElementDef
            def initialize(id, name, purpose, min_length, max_length)
              if min_length == 2 or min_length == 4 or min_length >= 6
                raise ArgumentError,
                  "Minimum length must be either 2, 4, 6, or greater"
              end

              if max_length == 2 or max_length == 4 or max_length >= 6
                raise ArgumentError,
                  "Maximum length must be either 2, 4, 6, or greater"
              end

              super(id, name, purpose, min_length, max_length)
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

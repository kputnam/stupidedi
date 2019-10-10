# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module Common
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

            if min_length < 1
              raise Exceptions::InvalidSchemaError,
                "min_length must be positive"
            end

            if min_length > max_length
              raise Exceptions::InvalidSchemaError,
                "min_length cannot be greater than max_length"
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

          # Constructs a SimpleElementVal from the given `value`
          #
          # @return [Values::SimpleElementVal]
          def value(object, usage, position)
            companion.value(object, usage, position)
          end

          # Constructs an empty SimpleElementVal
          #
          # @return [Values::SimpleElementVal]
          def empty(usage, position)
            companion.empty(usage, position)
          end
        end
      end
    end
  end
end

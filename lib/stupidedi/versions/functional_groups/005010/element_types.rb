# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module ElementTypes

          autoload :Operators,
            "stupidedi/versions/functional_groups/005010/element_types/operators"

          autoload :DateVal,
            "stupidedi/versions/functional_groups/005010/element_types/date_val"

          autoload :DT,
            "stupidedi/versions/functional_groups/005010/element_types/date_val"

          autoload :FloatVal,
            "stupidedi/versions/functional_groups/005010/element_types/float_val"

          autoload :R,
            "stupidedi/versions/functional_groups/005010/element_types/float_val"

          autoload :IdentifierVal,
            "stupidedi/versions/functional_groups/005010/element_types/identifier_val"

          autoload :ID,
            "stupidedi/versions/functional_groups/005010/element_types/identifier_val"

          autoload :FixnumVal,
            "stupidedi/versions/functional_groups/005010/element_types/fixnum_val"

          autoload :Nn,
            "stupidedi/versions/functional_groups/005010/element_types/fixnum_val"

          autoload :StringVal,
            "stupidedi/versions/functional_groups/005010/element_types/string_val"

          autoload :AN,
            "stupidedi/versions/functional_groups/005010/element_types/string_val"

          autoload :TimeVal,
            "stupidedi/versions/functional_groups/005010/element_types/time_val"

          autoload :TM,
            "stupidedi/versions/functional_groups/005010/element_types/time_val"

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

            # Constructs a SimpleElementVal from the given `String`
            #
            # @return [Values::SimpleElementVal]
            def parse(string, usage)
              companion.parse(string, usage)
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

        end
      end
    end
  end
end

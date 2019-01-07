# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Interchanges
    module ElementTypes
      class Separator < Versions::Common::ElementTypes::AN
        def companion
          SeparatorVal
        end
      end

      class SeparatorVal < Values::SimpleElementVal
        def_delegators :@value, :to_s, :length

        def initialize(value, usage, position)
          @value = value
          super(usage, position)
        end

        # @return [SeparatorVal]
        def copy(changes = {})
          SeparatorVal.new \
            changes.fetch(:value, @value),
            changes.fetch(:usage, usage),
            changes.fetch(:position, position)
        end

        def valid?
          true
        end

        def empty?
          @value.blank?
        end

        def too_short?
          @value.length < 1
        end

        def too_long?
          @value.length > 1
        end

        def separator?
          true
        end

        # @return [String]
        def to_x12
          @value.to_s
        end

        def inspect
          id = definition.try{|d| ansi.bold("[#{d.id}]") }
          ansi.element("SeparatorVal.value#{id}") + "(#{@value || "nil"})"
        end
      end

      class << SeparatorVal
        # @group Constructors
        ###################################################################

        # @raise NoMethodError
        def empty(usage, position)
          SeparatorVal.new(nil, usage, position)
        end

        # @return [SeparatorVal]
        def value(character, usage, position)
          SeparatorVal.new(character, usage, position)
        end

        # @return [SeparatorVal]
        def parse(character, usage, position)
          SeparatorVal.new(character, usage, position)
        end

        # @endgroup
        ###################################################################
      end
    end
  end
end

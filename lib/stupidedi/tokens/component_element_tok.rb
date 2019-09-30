# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Tokens
    class ComponentElementTok
      include Inspect

      # @return [String]
      attr_reader :value

      # @return [Position]
      attr_reader :position

      def initialize(value, position)
        @value    = value
        @position = position
      end

      # @return [CompositeElementTok]
      def copy(changes = {})
        ComponentElementTok.new \
          changes.fetch(:value, @value),
          changes.fetch(:position, @position)
      end

      # :nocov:
      def pretty_print(q)
        q.pp(:component.cons(@value.cons))
      end
      # :nocov:

      def blank?
        @value.blank?
      end

      def present?
        not blank?
      end

      def simple?
        true
      end

      def composite?
        false
      end

      def repeated?
        false
      end

      def to_x12(separators)
        @value.to_s
      end
    end

    class << ComponentElementTok
      #########################################################################
      # @group Constructors

      # @return [ComponentElementTok]
      def build(value, position)
        new(value, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end

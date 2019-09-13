# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Tokens
    class SimpleElementTok
      include Inspect

      # @return [String, Object]
      attr_reader :value

      # @return [Position]
      attr_reader :position

      def initialize(value, position)
        @value    = value
        @position = position
      end

      # @return [SimpleElementTok]
      def copy(changes = {})
        SimpleElementTok.new \
          changes.fetch(:value, @value),
          changes.fetch(:position, @position)
      end

      def pretty_print(q)
        q.pp(:simple.cons(@value.cons))
      end

      def repeated?
        false
      end

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

      def to_x12(separators)
        @value.to_s
      end
    end

    class << SimpleElementTok
      #########################################################################
      # @group Constructors

      def build(value, position)
        new(value, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end

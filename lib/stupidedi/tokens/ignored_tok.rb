# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Tokens
    class IgnoredTok
      # include Inspect

      # @return [String]
      attr_reader :value

      # @return [Position]
      attr_reader :position

      def initialize(value, position)
        @value, @position =
          value, position
      end

      # @return [IgnoredTok]
      def copy(changes = {})
        IgnoredTok.new \
          changes.fetch(:value, @value),
          changes.fetch(:position, @position)
      end

      # :nocov:
      def pretty_print(q)
        q.pp([:ignored, @value])
      end
      # :nocov:

      def blank?
        @value.blank?
      end

      def present?
        not blank?
      end

      def to_x12(separators)
        ""
      end
    end

    class << IgnoredTok
      #########################################################################
      # @group Constructors

      # @return [IgnoredTok]
      def build(value, position)
        new(value, position)
      end

      # @endgroup
      #########################################################################
    end
  end
end

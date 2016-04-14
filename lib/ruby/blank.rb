# frozen_string_literal: true

module Stupidedi
  module Refinements

    refine String do
      # True if the string is `empty?` or contains all whitespace
      #
      # @example
      #   "abc".blank?    #=> false
      #   "   ".blank?    #=> true
      #   "".blank?       #=> true
      #
      def blank?
        self !~ /\S/
      end

      def present?
        self =~ /\S/
      end
    end

    refine NilClass do
      # Always `true`. Note this overrides {Object#blank?} which returns false.
      #
      # @example
      #   nil.blank?    #=> true
      #
      def blank?
        true
      end

      def present?
        false
      end
    end

    refine Object do
      # Always `false`. Note that {NilClass#blank?} is overridden to return `true`
      #
      # @example
      #   false.blank?    #=> false
      #   100.blank?      #=> false
      #
      def blank?
        false
      end

      def present?
        true
      end
    end

  end
end

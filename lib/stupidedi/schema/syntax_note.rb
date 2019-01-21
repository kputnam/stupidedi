# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # The 5010 X12 "condition code"s include
    #   P - Paired or Multiple (if one then all)
    #   R - Required (at least one)
    #   E - Exclusion (no more than one)
    #   C - Conditional (if first then all)
    #   L - List Conditional (if first than at least one more)
    #
    # @see X222.pdf B.1.1.3.5 Syntax Notes
    # @see X222.pdf B.1.1.3.9 Condition Designator
    #
    class SyntaxNote
      # @return [Array<Integer>]
      attr_reader :indexes

      def initialize(indexes)
        @indexes = indexes
      end

      # Returns the AbstractElementVals from the given segment or composite
      # element that must be present, given the presence of other elements
      #
      # @return [Array<Zipper::AbstractCursor<Values::AbstractElementVal>>]
      abstract :required, :args => %w(zipper)

      # Returns the AbstractElementVals from the given segment or composite
      # element that must not be present, given the presence of other elements
      #
      # @return [Array<Zipper::AbstractCursor<Values::AbstractElementVal>>]
      abstract :forbidden, :args => %w(zipper)

      # @return [String]
      abstract :reason, :args => %w(zipper)

      def satisfied?(zipper)
        forbidden(zipper).all?{|c| c.node.blank? } and
          required(zipper).all?{|c| c.node.present? }
      end

    private

      def children(zipper)
        indexes.map{|n| zipper.child(n - 1) }
      end
    end
  end
end

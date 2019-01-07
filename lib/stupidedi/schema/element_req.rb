# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # The 5010 X12 "condition designator"s include
    #   M - Mandatory
    #   O - Optional
    #   X - Relational
    #
    # Where "Relational" indicates this element is subject to relational
    # conditions between two or more elements (encoded as a SyntaxNote)
    #
    # @see X222 B.1.1.3.9 Condition Designator
    #
    # The "Implementation Usage" from the 5010 HIPAA implementation guides
    # have three descriptors:
    #   REQUIRED
    #   NOT USED
    #   SITUATIONAL
    #
    # @see X222.pdf 2.2.1 Industry Usage
    #
    class ElementReq
      def initialize(required, forbidden, to_s)
        @required, @forbidden, @to_s =
          required, forbidden, to_s
      end

      # True if the element's presence is unconditionally required
      def required?
        @required
      end

      # True if the element's presence is unconditionally forbidden
      def forbidden?
        @forbidden
      end

      # True if the element's presence is required conditionally
      def optional?
        not (@required or @forbidden)
      end

      # @return [void]
      def pretty_print(q)
        q.text @to_s
      end

      # @return [String]
      def inspect
        @to_s
      end
    end
  end
end

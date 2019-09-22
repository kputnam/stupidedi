# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Schema
    #
    # The 5010 X12 "data segment requirement designator"s include
    #   M - Mandatory
    #   O - Optional
    #
    # @see X222 B.1.3.12.6 Data Segment Requirement Designators
    #
    # The HIPAA implementation guides "industry usage" include
    #   SITUATIONAL
    #   REQUIRED
    #
    class SegmentReq
      def initialize(required, forbidden, to_s)
        @required  = required
        @forbidden = forbidden
        @to_s      = to_s
      end

      def required?
        @required
      end

      def forbidden?
        @forbidden
      end

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

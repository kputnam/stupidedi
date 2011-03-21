module Stupidedi
  module Guides
    module FiftyTen

      #
      # @see X222.pdf 2.2 Implementation Usage
      #
      module SegmentReqs

        # Declares that this segment must always be sent. Required segments
        # within Situational loops only occur when the loop occurs.
        Required = Schema::SegmentReq.new(true,  false, "R")

        # Use of this segment varies, depending on data content and business
        # context as described in the defining rule. The defining rule is
        # documented in a Situational Rule attached to the segment.
        #
        # There are two forms of Situational Rules. The first is "Required when
        # <condition>. If not required by <condition>, the segment may be
        # provided at the discretion of the sender, but it cannot be required or
        # requested by the receiver.'
        #
        # The other form is "Required when <condition>. If not required by
        # <condition>, do not send". The segment described by the rule cannot
        # occur except when the condition holds.
        Situational = Schema::SegmentReq.new(false, false, "S")

      end

    end
  end
end

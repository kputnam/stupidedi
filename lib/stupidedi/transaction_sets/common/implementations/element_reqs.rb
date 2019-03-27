# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module Common
      module Implementations
        #
        # @see X222.pdf 2.2 Implementation Usage
        #
        module ElementReqs
          # Declares that this element must always be sent. Required elements
          # within Situational segments when the segment occurs.
          #
          # Similarly, required component elements within situational composite
          # elements only occur when the composite element occurs.
          Required = Schema::ElementReq.new(true,  false, "R")

          # Use of this element varies, depending on data content and business
          # context as described in the defining rule. The defining rule is
          # documented in a Situational Rule attached to the element.
          #
          # There are two forms of Situational Rules. The first is "Required when
          # <condition>. If not required by <condition>, the element may be
          # provided at the discretion of the sender, but it cannot be required or
          # requested by the receiver.'
          #
          # The other form is "Required when <condition>. If not required by
          # <condition>, do not send". The element described by the rule cannot
          # occur except when the condition holds.
          Situational = Schema::ElementReq.new(false, false, "S")

          # This element must never be sent.
          NotUsed = Schema::ElementReq.new(false, true,  "N")
        end
      end
    end
  end
end

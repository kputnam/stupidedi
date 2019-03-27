# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @note: Definition might be outdated, working from ANSI X12 2001 specification
        BPS = s::SegmentDef.build(:BPS, "Beginning Segment for Payment Order/Remittance Advice",
          "To (1) indicate the beginning of a payment order/remittance advice
          transaction set and total payment and (2) to enable related transfer
          of funds and/or information from payor to payee to occur while
          utilizing an automated clearing house (ACH) or other banking
          network",
          e::E591.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E782.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E305.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E352.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E508.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E513.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        CTT = s::SegmentDef.build(:CTT, "Transaction Totals",
          "To transmit a hash total for a specific element in the transaction
          set",
          e::E354 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

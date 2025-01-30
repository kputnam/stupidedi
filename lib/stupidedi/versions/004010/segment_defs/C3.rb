# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        C3  = s::SegmentDef.build(:C3, "Currency",
          "To specify the currency being used in the transaction set",
          e::E100 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E280 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E100 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

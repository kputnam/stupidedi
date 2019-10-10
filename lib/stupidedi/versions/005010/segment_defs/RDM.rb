# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        RDM = s::SegmentDef.build(:RDM, "Remittance Delivery Method",
          "To identify remittance delivery when remittance is separate from
          payment",
          e::E756 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E93  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E364 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C040 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C040 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

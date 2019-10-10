# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        N9  = s::SegmentDef.build(:N9 , "Reference Identification",
          "To transmit identifying information as specified by the Reference
          Identification Qualifier",
          e::E128 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

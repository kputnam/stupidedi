# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        IK3 = s::SegmentDef.build(:IK3, "Transaction Set Response Header",
          "To start acknowledgement of a single transaction set",
          e::E721 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E719 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E447 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E620 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

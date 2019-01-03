# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        DTM = s::SegmentDef.build(:DTM, "Date/Time Reference",
          "To specify pertinent dates and times",
          e::E374 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E624 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

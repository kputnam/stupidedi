# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        BEG = s::SegmentDef.build(:BEG, "Beginning Segment for Purchase Order",
          "To indicate the beginning of the Purchase Order Transaction Set and
          transmit identifying numbers and dates",
          e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E92  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E324 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E328 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E323 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

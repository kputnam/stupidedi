# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        BAK = s::SegmentDef.build(:BAK, "Beginning Segment for Purchase Order Acknowledgment",
          "To indicate the beginning of the Purchase Order Acknowledgment
          Transaction Set and transmit identifying numbers and dates",
          e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E587 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E324 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E367 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

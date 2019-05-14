# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        B4  = s::SegmentDef.build(:B4, "Beginning Segment for Inquiry or Reply",
          "To transmit identifying numbers, dates, and other basic data relating to the transaction set",
          e::E152 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E71  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E157 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E161 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E159 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E206 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E207 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E578 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E24  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E310 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E309 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E761 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

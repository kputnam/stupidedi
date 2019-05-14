# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        Q2  = s::SegmentDef.build(:Q2, "Status Details (Ocean)",
          "To transmit identifying information relative to identification of vessel, transportation dates, lading quantity, weight, and cube",
          e::E597 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E26  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E80  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E81  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E187 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E55  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E128 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E897 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E182 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E183 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E184 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E188 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

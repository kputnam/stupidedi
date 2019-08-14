# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        IT1 = s::SegmentDef.build(:IT1, "Beginning Segment for Invoice",
          "To indicate the beginning of the Invoice Transaction Set and
          transmit identifying numbers and dates",
          e::E22.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end
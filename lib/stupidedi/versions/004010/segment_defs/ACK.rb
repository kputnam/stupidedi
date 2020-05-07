# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        ACK = s::SegmentDef.build(:ACK, "Line Item Acknowledgment",
          "To start acknowledgement of a line item",
          e::E668 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E374 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E326 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
          e::E1271  .simple_use(r::Optional,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

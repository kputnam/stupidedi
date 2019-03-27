# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MIA = s::SegmentDef.build(:MIA, "Medicare Inpatient Adjudication",
          "To provide claim-level data related to the adjudication of Medicare
          inpatient claims",
          e::E380 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

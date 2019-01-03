# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MOA = s::SegmentDef.build(:MOA, "Medicare Outpatient Adjudication",
          "To convey claim-level data related to the adjudication of Medicare
          claims not related to an inpatient setting",
          e::E954 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

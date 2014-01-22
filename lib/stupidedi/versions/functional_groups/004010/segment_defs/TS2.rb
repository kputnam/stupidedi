module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          TS2 = s::SegmentDef.build(:TS2, "Transaction Supplemental Statistics",
            "To supply supplemental summary control information by provider fiscal year and bill type",
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

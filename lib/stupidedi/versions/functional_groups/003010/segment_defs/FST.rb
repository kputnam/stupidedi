module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          FST = s::SegmentDef.build(:FST, "Forecast Schedule",
            "To specify the forecasted dates and quantities",
            e::E380 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E680 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E681 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E374 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E128 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Relational,  s::RepeatCount.bounded(1)))


            # SyntaxNotes::P.build(6, 7),
            # SyntaxNotes::P.build(1, 2, 3))

        end
      end
    end
  end
end

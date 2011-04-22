module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          HCP = s::SegmentDef.build(:HCP, "Health Care Pricing",
            "To specify pricing or repricing information about a health care claim or line item",
            e::E1473.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E118 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E901 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1526.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1527.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build( 1, 13),
            SyntaxNotes::P.build( 9, 10),
            SyntaxNotes::P.build(11, 12))

        end
      end
    end
  end
end

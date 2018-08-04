module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          EQ = s::SegmentDef.build(:EQ, "Eligibility or Benefit Inquiry",
            "To specify inquired eligibility or benefit information",
            e::E1365.simple_use(r::Relational, s::RepeatCount.bounded(99)),
            e::C003 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1207.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1336.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C004 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(1, 2))

        end
      end
    end
  end
end

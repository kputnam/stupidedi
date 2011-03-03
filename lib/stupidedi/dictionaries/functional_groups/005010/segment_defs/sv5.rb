module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SV5 = s::SegmentDef.build(:SV5, "Durable Medical Equipment Service",
            "To specify the claim service detail for durable medical equipment",
            e::C003 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E594 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E923 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(4, 5),
            SyntaxNotes::C.build(6, 5))

        end
      end
    end
  end
end

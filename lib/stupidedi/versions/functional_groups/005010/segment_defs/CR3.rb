module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CR3 = s::SegmentDef.build(:CR3, "Durable Medical Equipment Certification",
            "To supply information regarding a physician's certification for durable medical equipment",
            e::E1322.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1335.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(2, 3))

        end
      end
    end
  end
end

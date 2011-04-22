module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CR1 = s::SegmentDef.build(:CR1, "Ambulance Certification",
            "To supply information related to the ambulance service rendered to a patient",
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1316.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1317.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E166 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E166 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1, 2),
            SyntaxNotes::P.build(5, 6))

        end
      end
    end
  end
end

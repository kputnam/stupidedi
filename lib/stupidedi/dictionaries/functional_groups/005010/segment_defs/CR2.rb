module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CR2 = s::SegmentDef.build(:CR2, "Chiropractic Certification",
            "To supply information related to the chiropractic service rendered to a patient",
            e::E609 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1367.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1367.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1342.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1, 2),
            SyntaxNotes::C.build(4, 3),
            SyntaxNotes::P.build(5, 6))

        end
      end
    end
  end
end

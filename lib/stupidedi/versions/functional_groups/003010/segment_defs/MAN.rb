module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          MAN = s::SegmentDef.build(:MAN, "Marks and Numbers",
            "To indicate identifying marks and numbers for shipping containers",
            e::E88  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E87  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E87  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E88  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E87  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E87  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(4, 5),
            SyntaxNotes::C.build(6, 5))

        end
      end
    end
  end
end

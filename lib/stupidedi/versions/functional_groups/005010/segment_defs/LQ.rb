module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LQ = s::SegmentDef.build(:LQ, "Industry Code Identification",
            "To identify standard industry codes",
            e::E1270.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1271.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::C.build(1, 2))

        end
      end
    end
  end
end

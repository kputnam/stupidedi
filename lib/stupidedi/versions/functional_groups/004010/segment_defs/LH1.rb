module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LH1 = s::SegmentDef.build(:LH1, "Hazardous Identification Information",
            "To specify the hazardous commodity identification reference number and quantity",
            e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E80  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E277 .simple_use(r::Optional ,  s::RepeatCount.bounded(1)),
            e::E200 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E22  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E595 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E665 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E254 .simple_use(r::Optional ,  s::RepeatCount.bounded(1)),
            e::E1375.simple_use(r::Optional ,  s::RepeatCount.bounded(1)),
            e::E1271.simple_use(r::Optional ,  s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(6 ,7))

        end
      end
    end
  end
end

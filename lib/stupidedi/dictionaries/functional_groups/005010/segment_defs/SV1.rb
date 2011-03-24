module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SV1 = s::SegmentDef.build(:SV1, "Professional Service",
            "To specify the service line item detail for a health care professional",
            e::C003 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1331.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1365.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::C004 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1340.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E1364.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1341.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1327.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1334.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E116 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1337.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1360.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(3, 4))

        end
      end
    end
  end
end

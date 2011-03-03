module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          SV1 = SegmentDef.build :SV1, "Professional Service",
            "To specify the service line item detail for a health care professional",
            E::C003 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1331.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1365.simple_use(Optional,   RepeatCount.bounded(1)),

            E::C004 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1340.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),

            E::E1364.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1341.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1327.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1334.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E116 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1337.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1360.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.build(3, 4)

        end
      end
    end
  end
end

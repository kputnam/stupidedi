module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          PAT = SegmentDef.build :PAT, "Patient Information",
            "To supply patient information",
            E::E1069.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1384.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E584 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1220.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1250.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1251.simple_use(Relational, RepeatCount.bounded(1)),

            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E81  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.build(5, 6),
            SyntaxNote::P.build(7, 8)

        end
      end
    end
  end
end

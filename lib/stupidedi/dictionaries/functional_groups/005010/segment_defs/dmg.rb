module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          DMG = SegmentDef.build :DMG, "Demographic Information",
            "To supply demographic information",
            E::E1250.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1251.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1068.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1067.simple_use(Optional,   RepeatCount.bounded(1)),
            E::C056 .simple_use(Relational, RepeatCount.bounded(10)),
            E::E1066.simple_use(Optional,   RepeatCount.bounded(1)),

            E::E26  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1270.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1271.simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::P.build( 1,  2),
            SyntaxNote::P.build(10, 11),
            SyntaxNote::C.build(11,  5)

        end
      end
    end
  end
end

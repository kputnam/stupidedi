module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CR2 = SegmentDef.build :CR2, "Chiropractic Certification",
            "To supply information related to the chiropractic service rendered to a patient",
            E::E609 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1367.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1367.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1342.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.build(1, 2),
            SyntaxNote::C.build(4, 3),
            SyntaxNote::P.build(5, 6)

        end
      end
    end
  end
end

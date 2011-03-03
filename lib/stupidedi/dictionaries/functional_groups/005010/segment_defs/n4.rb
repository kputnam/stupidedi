module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          N4 = SegmentDef.build :N4, "Geographic Location",
            "To specify the geographic place of the named party",
            E::E19  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E156 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E116 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E26  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E309 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E310 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E1715.simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::E.build(2, 7),
            SyntaxNote::C.build(6, 5),
            SyntaxNote::C.build(7, 4)

        end
      end
    end
  end
end

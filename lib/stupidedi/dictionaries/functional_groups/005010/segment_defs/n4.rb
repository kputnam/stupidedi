module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          N4 = SegmentDef.new :N4, "Geographic Location",
            "To specify the geographic place of the named party",
            E::E19  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E156 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E116 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E26  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E309 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E310 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E1715.simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::E.new(2, 7),
            SyntaxNote::C.new(6, 5),
            SyntaxNote::C.new(7, 4)

        end
      end
    end
  end
end

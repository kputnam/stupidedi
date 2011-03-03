module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          PER = SegmentDef.build :PER, "Administrative Communications Contact",
            "To identify a person or office to whom administrative communications should be directed",
            E::E366 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E93  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E365 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E364 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E365 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E364 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E365 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E364 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E443 .simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.build(3, 4),
            SyntaxNote::P.build(5, 6),
            SyntaxNote::P.build(7, 8)

        end
      end
    end
  end
end

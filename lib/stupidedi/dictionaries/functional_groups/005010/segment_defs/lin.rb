module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          LIN = SegmentDef.build :LIN, "Item Identification",
            "To specify basic item identification data",
            E::E350 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E235 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E234 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::P.build( 4,  5),
            SyntaxNote::P.build( 6,  7),
            SyntaxNote::P.build( 8,  9),
            SyntaxNote::P.build(10, 11),
            SyntaxNote::P.build(12, 13),
            SyntaxNote::P.build(14, 15),
            SyntaxNote::P.build(16, 17),
            SyntaxNote::P.build(18, 19),
            SyntaxNote::P.build(20, 21),
            SyntaxNote::P.build(22, 23),
            SyntaxNote::P.build(24, 25),
            SyntaxNote::P.build(26, 27),
            SyntaxNote::P.build(28, 29),
            SyntaxNote::P.build(30, 31)

        end
      end
    end
  end
end

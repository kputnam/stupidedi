module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CUR = SegmentDef.build :CUR, "Currency",
            "To specify the currency (dollars, pounds, francs, etc) used in a transaction",
            E::E98  .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E100 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E280 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E98  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E100 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E669 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E374 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E337 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E374 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E337 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E374 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E337 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E374 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E337 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E374 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E337 .simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::C.build( 8,  7),
            SyntaxNote::C.build( 9,  7),
            SyntaxNote::L.build(10, 11, 12),
            SyntaxNote::C.build(11, 10),
            SyntaxNote::C.build(12, 10),
            SyntaxNote::L.build(13, 14, 15),
            SyntaxNote::C.build(14, 13),
            SyntaxNote::C.build(15, 13),
            SyntaxNote::L.build(16, 17, 18),
            SyntaxNote::C.build(17, 16),
            SyntaxNote::C.build(18, 16),
            SyntaxNote::L.build(19, 20, 21),
            SyntaxNote::C.build(20, 19),
            SyntaxNote::C.build(21, 19)

        end
      end
    end
  end
end

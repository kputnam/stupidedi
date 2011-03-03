module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          CUR = SegmentDef.new \
            :CUR, "Currency",
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

            SyntaxNote::C.new( 8,  7),
            SyntaxNote::C.new( 9,  7),
            SyntaxNote::L.new(10, 11, 12),
            SyntaxNote::C.new(11, 10),
            SyntaxNote::C.new(12, 10),
            SyntaxNote::L.new(13, 14, 15),
            SyntaxNote::C.new(14, 13),
            SyntaxNote::C.new(15, 13),
            SyntaxNote::L.new(16, 17, 18),
            SyntaxNote::C.new(17, 16),
            SyntaxNote::C.new(18, 16),
            SyntaxNote::L.new(19, 20, 21),
            SyntaxNote::C.new(20, 19),
            SyntaxNote::C.new(21, 19)

        end
      end
    end
  end
end

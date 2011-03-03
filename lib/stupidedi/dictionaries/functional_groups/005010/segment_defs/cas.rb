module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CAS = SegmentDef.build :CAS, "Claims Adjustment",
            "To supply adjustment reason codes and amounts as needed for an entire claim or for a particular service within the claim being paid",
            E::E1033.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1034.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1034.simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1034.simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1034.simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1034.simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1034.simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::L.build( 5,  6,  7),
            SyntaxNote::C.build( 6,  5),
            SyntaxNote::C.build( 7,  5),
            SyntaxNote::L.build( 8,  9, 10),
            SyntaxNote::C.build( 9,  8),
            SyntaxNote::C.build(10,  8),
            SyntaxNote::L.build(11, 12, 13),
            SyntaxNote::C.build(12, 11),
            SyntaxNote::C.build(13, 11),
            SyntaxNote::L.build(14, 15, 16),
            SyntaxNote::C.build(15, 14),
            SyntaxNote::C.build(16, 14),
            SyntaxNote::L.build(17, 18, 19),
            SyntaxNote::C.build(18, 17),
            SyntaxNote::C.build(19, 17)

        end
      end
    end
  end
end

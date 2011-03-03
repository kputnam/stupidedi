module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          CAS = SegmentDef.new \
            :CAS, "Claims Adjustment",
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

            SyntaxNote::L.new( 5,  6,  7),
            SyntaxNote::C.new( 6,  5),
            SyntaxNote::C.new( 7,  5),
            SyntaxNote::L.new( 8,  9, 10),
            SyntaxNote::C.new( 9,  8),
            SyntaxNote::C.new(10,  8),
            SyntaxNote::L.new(11, 12, 13),
            SyntaxNote::C.new(12, 11),
            SyntaxNote::C.new(13, 11),
            SyntaxNote::L.new(14, 15, 16),
            SyntaxNote::C.new(15, 14),
            SyntaxNote::C.new(16, 14),
            SyntaxNote::L.new(17, 18, 19),
            SyntaxNote::C.new(18, 17),
            SyntaxNote::C.new(19, 17)

        end
      end
    end
  end
end

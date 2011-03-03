module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          LIN = SegmentDef.new :LIN, "Item Identification",
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

            SyntaxNote::P.new( 4,  5),
            SyntaxNote::P.new( 6,  7),
            SyntaxNote::P.new( 8,  9),
            SyntaxNote::P.new(10, 11),
            SyntaxNote::P.new(12, 13),
            SyntaxNote::P.new(14, 15),
            SyntaxNote::P.new(16, 17),
            SyntaxNote::P.new(18, 19),
            SyntaxNote::P.new(20, 21),
            SyntaxNote::P.new(22, 23),
            SyntaxNote::P.new(24, 25),
            SyntaxNote::P.new(26, 27),
            SyntaxNote::P.new(28, 29),
            SyntaxNote::P.new(30, 31)

        end
      end
    end
  end
end

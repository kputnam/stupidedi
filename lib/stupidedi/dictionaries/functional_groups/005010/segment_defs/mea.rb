module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          MEA = SegmentDef.new \
            :MEA, "Measurements",
            "To specify physical measurements or counts, including dimensions, tolerances, variances, and weights",
            E::E737 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E738 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E739 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C001 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E740 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E741 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E935 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E936 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E752 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E753 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1270.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1271.simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::R.new( 3,  5,  6,  8),
            SyntaxNote::E.new( 4, 12),
            SyntaxNote::L.new( 5,  4, 12),
            SyntaxNote::L.new( 6,  4, 12),
            SyntaxNote::L.new( 7,  3,  5,  6),
            SyntaxNote::E.new( 8,  3),
            SyntaxNote::P.new(11, 12)

        end
      end
    end
  end
end

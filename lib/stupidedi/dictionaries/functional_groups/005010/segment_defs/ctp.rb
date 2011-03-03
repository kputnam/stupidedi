module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CTP = SegmentDef.build :CTP, "Pricing Information",
            "To specify pricing information",
            E::E687 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E236 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E212 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C001 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E648 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E649 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E639 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E499 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E289 .simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.build( 4,  5),
            SyntaxNote::C.build( 6,  7),
            SyntaxNote::C.build( 9,  2),
            SyntaxNote::C.build(10,  2),
            SyntaxNote::C.build(11,  3)

        end
      end
    end
  end
end

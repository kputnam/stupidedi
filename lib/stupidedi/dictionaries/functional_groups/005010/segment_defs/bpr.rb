module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          BPR = SegmentDef.build :BPR, "Financial Information",
            E::DE305 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::DE782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::DE478 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::DE591 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::DE812 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE506 .simple_use(Relational, RepeatCount.bounded(1)),

            E::DE507 .simple_use(Relational, RepeatCount.bounded(1)),
            E::DE569 .simple_use(Relational, RepeatCount.bounded(1)),
            E::DE508 .simple_use(Relational, RepeatCount.bounded(1)),
            E::DE509 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE510 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE506 .simple_use(Relational, RepeatCount.bounded(1)),

            E::DE507 .simple_use(Relational, RepeatCount.bounded(1)),
            E::DE569 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE508 .simple_use(Relational, RepeatCount.bounded(1)),
            E::DE373 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE1048.simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE506 .simple_use(Relational, RepeatCount.bounded(1)),

            E::DE507 .simple_use(Relational, RepeatCount.bounded(1)),
            E::DE569 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::DE508 .simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::P.build( 6,  7),
            SyntaxNote::C.build( 8,  9),
            SyntaxNote::P.build(12, 13),
            SyntaxNote::C.build(14, 15),
            SyntaxNote::P.build(18, 19),
            SyntaxNote::C.build(20, 21)

        end
      end
    end
  end
end

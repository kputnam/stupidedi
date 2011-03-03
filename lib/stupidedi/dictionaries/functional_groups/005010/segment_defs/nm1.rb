module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          NM1 = SegmentDef.build :NM1, "Individual or Organizational Name",
            "To supply the full name of an individual or organizational entity",
            E::E98  .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1065.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1035.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1036.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1037.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1038.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1039.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E66  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E67  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E706 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E98  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1035.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.build( 8,  9),
            SyntaxNote::C.build(11, 10),
            SyntaxNote::C.build(12,  3)

        end
      end
    end
  end
end

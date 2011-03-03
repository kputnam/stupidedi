module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          QTY = SegmentDef.build :QTY, "Quantity Information",
            "To specify quantity information",
            E::E673.simple_use(Mandatory,   RepeatCount.bounded(1)),
            E::E380.simple_use(Relational,  RepeatCount.bounded(1)),
            E::C001.simple_use(Optional,    RepeatCount.bounded(1)),
            E::E61 .simple_use(Relational,  RepeatCount.bounded(1)),

            SyntaxNote::R.build(2, 4),
            SyntaxNote::E.build(2, 5)

        end
      end
    end
  end
end

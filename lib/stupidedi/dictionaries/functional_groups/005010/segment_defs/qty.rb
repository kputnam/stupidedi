module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          QTY = SegmentDef.new :QTY, "Quantity Information",
            "To specify quantity information",
            E::E673.simple_use(Mandatory,   RepeatCount.bounded(1)),
            E::E380.simple_use(Relational,  RepeatCount.bounded(1)),
            E::C001.simple_use(Optional,    RepeatCount.bounded(1)),
            E::E61 .simple_use(Relational,  RepeatCount.bounded(1)),

            SyntaxNote::R.new(2, 4),
            SyntaxNote::E.new(2, 5)

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CR3 = SegmentDef.new :CR3, "Durable Medical Equipment Certification",
            "To supply information regarding a physician's certification for durable medical equipment",
            E::E1322.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1335.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.new(2, 3)

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          SV5 = SegmentDef.build :SV5, "Durable Medical Equipment Service",
            "To specify the claim service detail for durable medical equipment",
            E::C003 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E355 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E594 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E923 .simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::R.build(4, 5),
            SyntaxNote::C.build(6, 5)

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PLD = s::SegmentDef.build(:PLD, "Pallet Information",
            "To specify pallet information including quantity, exchange, and weight",
            e::E406 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E399 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(3, 4))

        end
      end
    end
  end
end

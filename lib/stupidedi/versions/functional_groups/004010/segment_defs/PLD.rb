module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PLD = s::SegmentDef.build(:PLD, "Pallet Information",
            "To specify pallet information including quantity, exchange, and weight",
            e::E406.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W06 = s::SegmentDef.build(:W06, "Warehouse Shipment Identification",
            "To provide identifying numbers, dates, and other basic data for this transaction set",
            e::E514.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E285.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E373.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E145.simple_use(r::Optional, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

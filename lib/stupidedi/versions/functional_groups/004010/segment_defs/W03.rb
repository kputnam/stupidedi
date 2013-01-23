module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W03 = s::SegmentDef.build(:W03, "Total Shipment Information",
            "To provide totals relating to the shipment",
            e::E382.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E81.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E355.simple_use(r::Mandatory, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

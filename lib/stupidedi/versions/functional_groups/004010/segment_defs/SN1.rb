module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs 

        # Definition might be outdated, working from ANSI X12 2001 specification
        
          SN1 = s::SegmentDef.build(:SN1, "Item Detail (Shipment)",
            "To specify line-item detail relative to shipment",
            e::E382 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

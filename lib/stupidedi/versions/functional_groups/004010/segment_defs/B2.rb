module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          B2 = s::SegmentDef.build(:B2, "Beginning Segment for Shipment Information Transaction",
            "To transmit basic data relating to shipment information",
            e::E140 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E145 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E146 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

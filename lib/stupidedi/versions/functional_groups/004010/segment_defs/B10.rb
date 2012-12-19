module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          B10 = s::SegmentDef.build(:B10, "Beginning Segment for Transportation Carrier Shipment Status Message",
            "To transmit identifying numbers and other basic data relating to the transaction set",
            e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E145 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E140 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W05 = s::SegmentDef.build(:W05, "Shipping Order Identification",
            "Shipping Order Identification",
            e::E473.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E285.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E324.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E472.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E474.simple_use(r::Optional, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

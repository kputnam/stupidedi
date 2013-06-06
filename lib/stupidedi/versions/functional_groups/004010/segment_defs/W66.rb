module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W66 = s::SegmentDef.build(:W66, "Warehouse Carrier Information",
            "Warehouse Carrier Information",
            e::E146.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E91.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E399.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E61.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E387.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E61.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E61.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E61.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E61.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E140.simple_use(r::Optional, s::RepeatCount.bounded(1))
          )
        end
      end
    end
  end
end

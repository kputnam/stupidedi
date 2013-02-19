module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W07 = s::SegmentDef.build(:W07, "Item Detail For Stock Receipt",
            "To indicate quantity and condition of product received",
            e::E413.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E355.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E438.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E235.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E234.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E451.simple_use(r::Optional, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end


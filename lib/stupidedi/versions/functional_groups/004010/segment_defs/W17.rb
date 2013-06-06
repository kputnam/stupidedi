module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W17 = s::SegmentDef.build(:W17, "Warehouse Receipt Identification",
            "To provide identifying numbers and date",
            e::E514.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E394.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E285.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E145.simple_use(r::Optional, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

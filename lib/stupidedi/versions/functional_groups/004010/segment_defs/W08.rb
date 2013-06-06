module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W08 = s::SegmentDef.build(:W08, "Receipt Carrier Information",
            "To identify carrier equipment and condition.",
            e::E91.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E140.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E387.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E206.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E207.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E225.simple_use(r::Optional, s::RepeatCount.bounded(2))
          )
        end
      end
    end
  end
end


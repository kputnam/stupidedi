module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N7  = s::SegmentDef.build(:N7 , "Equipment Details",
            "To identify the equipment",
            e::E207.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E40 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E567.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

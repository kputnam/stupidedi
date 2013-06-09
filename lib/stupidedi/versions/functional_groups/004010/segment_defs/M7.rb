module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          M7  = s::SegmentDef.build(:M7 , "Seal Numbers",
            "To record seal numbers used and the organization that applied the seals",
            e::E225 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E225 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E225 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E225 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

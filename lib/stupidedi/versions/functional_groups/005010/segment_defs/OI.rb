module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          OI = s::SegmentDef.build(:OI, "Other Health Insurance Information",
            "To specify information associated with other health insurance coverage",
            e::E1032.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1383.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1351.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1360.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1363.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

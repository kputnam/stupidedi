module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SBR = s::SegmentDef.build(:SBR, "Subscriber Information",
            "To record information specific to the primary insured and the insurance carrier for that insured",
            e::E1138.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E1069.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E93  .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E1336.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E1143.simple_use(r::Optional,  s::RepeatCount.bounded(1)),

            e::E1073.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E584 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E1032.simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

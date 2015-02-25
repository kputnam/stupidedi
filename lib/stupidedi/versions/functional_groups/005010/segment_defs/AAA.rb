module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AAA = s::SegmentDef.build(:AAA, "Request Validation",
            "To specify the validity of the request and indicate follow-up action authorized",
            e::E1073.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E559 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E901 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E889 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

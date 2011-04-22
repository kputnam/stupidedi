module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          STC = s::SegmentDef.build(:STC, "Status Information",
            "To report the status, required action, and paid information of a claim or service line",
            e::C043 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E306 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E591 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E429 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C043 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C043 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E933 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

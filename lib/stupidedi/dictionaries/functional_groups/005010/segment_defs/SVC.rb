module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SVC = s::SegmentDef.build(:SVC, "Service Payment Information",
            "To supply payment and control information to a provider for a particular service",
            e::C003 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C003 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

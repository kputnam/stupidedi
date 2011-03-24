module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SV3 = s::SegmentDef.build(:SV3, "Dental Service",
            "To specify the service line item detail for dental work",
            e::C003 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1331.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C006 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1358.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1327.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1360.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C004 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

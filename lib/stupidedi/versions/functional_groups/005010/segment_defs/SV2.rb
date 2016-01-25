# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SV2 = s::SegmentDef.build(:SV2, "Institutional Service",
            "To specify the service line item detail for a health care institution",
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::C003 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1371.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1345.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1337.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

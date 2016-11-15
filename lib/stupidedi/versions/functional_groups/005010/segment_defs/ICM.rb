# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          ICM = s::SegmentDef.build(:ICM, "Individual Income",
            "To supply information to determine benefit eligibility, deductibles, and retirement and investment contributions",
            e::E594 .simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E310 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E1214.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E100 .simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end


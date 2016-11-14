# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          HLH = s::SegmentDef.build(:HLH, "Health Information",
            "To provide health information",
            e::E1212.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E65  .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E1213.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end


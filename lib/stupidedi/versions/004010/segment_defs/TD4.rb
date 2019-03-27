# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @note: Definition might be outdated, working from ANSI X12 2001 specification
        TD4 = s::SegmentDef.build(:TD4, "Carrier Details (Special Handling, or Hazardous Materials, or Both)",
          "To specify transportation special handling requirements, or hazardous
          materials information, or both",
          e::E152 .simple_use(r::Mandatory,  s::RepeatCount.bounded(2)),
          e::E208 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E209 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E352 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

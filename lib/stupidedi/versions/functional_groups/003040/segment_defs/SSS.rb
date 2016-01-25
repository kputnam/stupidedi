# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SSS = s::SegmentDef.build(:SSS, "Special Services",
            "To specify special conditions or services associated with the purchased product",
            e::E248 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E559 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E560 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E248 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E359 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E360 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E248 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

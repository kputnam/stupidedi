# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        HD  = s::SegmentDef.build(:HD, "Health Coverage",
          "To provide information on health coverage",
          e::E875 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1203.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1205.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1204.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1207.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E609 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E609 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1209.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1211.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        PLA = s::SegmentDef.build(:PLA, "Place or Location",
          "To indicate action to be taken for the location specified and to
          qualify the location specified",
          e::E306 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E98  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E337 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1203.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        IDC = s::SegmentDef.build(:IDC, "Identification Card",
          "To provide notification to produce replacement identification
          card(s)",
          e::E1204.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1215.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E306 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

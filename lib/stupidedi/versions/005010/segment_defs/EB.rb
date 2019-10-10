# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        EB  = s::SegmentDef.build(:EB, "Eligibility or Benefit Information",
          "To supply eligibility or benefit information",
          e::E1390.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1207.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1365.simple_use(r::Optional,   s::RepeatCount.bounded(99)),
          e::E1336.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1204.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E615 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E954 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E673 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C003 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C004 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(9, 10))
      end
    end
  end
end

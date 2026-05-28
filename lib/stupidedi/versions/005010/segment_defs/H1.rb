# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        H1 = s::SegmentDef.build(:H1, "Hazardous Material",
          "To specify information relating to hazardous materials",
          e::E62 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E209.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E208.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E64 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E63 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E200.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E77 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E254.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(7, 8))
      end
    end
  end
end

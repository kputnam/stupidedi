# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MSG = s::SegmentDef.build(:MSG, "Message Text",
          "To specify the service line item detail for a health care
          professional",
          e::E933 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E934 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1470.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::C.build(3, 2))
      end
    end
  end
end

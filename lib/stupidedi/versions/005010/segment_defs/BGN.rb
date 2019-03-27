# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        BGN = s::SegmentDef.build(:BGN, "Beginning Segment",
          "To indicate the beginning of a transaction set",
          e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E623 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E640 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E306 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E786 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::C.build(5, 4))
      end
    end
  end
end

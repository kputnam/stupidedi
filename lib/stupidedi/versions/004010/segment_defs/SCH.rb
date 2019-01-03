# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        SCH = s::SegmentDef.build(:SCH, "Line Item Schedule",
          "To specify the dat for scheduling aspecifc line-item",
          e::E380 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E93  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E374 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E374 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::C.build(3, 4))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        G62 = s::SegmentDef.build(:G62, "Date/Time",
          "To specify pertinent dates and times",
          e::E432 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E176 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E623 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(1, 2),
          SyntaxNotes::P.build(3, 4))
      end
    end
  end
end

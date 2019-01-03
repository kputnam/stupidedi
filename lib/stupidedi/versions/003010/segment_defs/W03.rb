# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        W03 = s::SegmentDef.build(:W03, "Total Shipment Information",
          "To provide totals relating to the shipment",
          e::E382 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E80  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(2, 3),
          SyntaxNotes::P.build(4, 5),
          SyntaxNotes::P.build(6, 7))
      end
    end
  end
end

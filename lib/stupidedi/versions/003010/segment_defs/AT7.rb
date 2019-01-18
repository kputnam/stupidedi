# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        AT7 = s::SegmentDef.build(:AT7, "Shipment Status Detail",
          "To specify the status of a shipment, the reason for that status,
          the date and time of the status and the date and time of any
          appointments scheduled",
          e::E1650.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1651.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1652.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1651.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E623 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::E.build(1, 3),
          SyntaxNotes::P.build(1, 2),
          SyntaxNotes::P.build(3, 4),
          SyntaxNotes::C.build(6, 5),
          SyntaxNotes::C.build(7, 6))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MS1 = s::SegmentDef.build(:MS1, "Equipment, Shipment, or Real Property Location",
          "To specify the location of a piece of equipment, a shipment, or real
          property in terms of city and state for the stop location that relates
          to the AT7 shipment status details",
          e::E19  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E156 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E26  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1654.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1655.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1280.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1280.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E116 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::L.build(1, 2, 3),
          SyntaxNotes::E.build(1, 4),
          SyntaxNotes::C.build(2, 1),
          SyntaxNotes::C.build(3, 1),
          SyntaxNotes::P.build(4, 5),
          SyntaxNotes::C.build(6, 4),
          SyntaxNotes::C.build(7, 4),
          SyntaxNotes::C.build(8, 1))
      end
    end
  end
end

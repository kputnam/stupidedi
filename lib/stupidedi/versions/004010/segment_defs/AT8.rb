# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        AT8 = s::SegmentDef.build(:AT8, "Shipment Weight, Packaging and Quantity Data",
          "To specify shipment details in terms of weight, and quantity of
          handling units",
          e::E187 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E80  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E80  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E184 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(6, 7),
          SyntaxNotes::P.build(1, 2, 3))
      end
    end
  end
end

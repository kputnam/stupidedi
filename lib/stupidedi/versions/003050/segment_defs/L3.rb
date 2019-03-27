# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        L3  = s::SegmentDef.build(:L3 , "Total Weight and Charges",
          "To specify the total shipment in terms of weight, volume, rates,
          charges, advances, and prepaid amounts applicable to one or more line
          items",
          e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E187 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E60  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E122 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E58  .simple_use(r::Optional  , s::RepeatCount.bounded(1)),
          e::E191 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E117 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E150 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E184 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E80  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E188 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E171 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E74  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E122 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build( 1,  2),
          SyntaxNotes::P.build( 3,  4),
          SyntaxNotes::P.build( 9, 10),
          SyntaxNotes::C.build(12,  1),
          SyntaxNotes::P.build(14, 15))
      end
    end
  end
end

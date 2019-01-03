# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        H3  = s::SegmentDef.build(:H3, "Line Item - Quantity and Weight",
          "To specify quantity, weight, volume, and type of service for a line
          item including applicable 'quantity/rate-as' data",
          e::E152 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E153 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E241 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E242 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E257 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::E.build(1, 2))
      end
    end
  end
end

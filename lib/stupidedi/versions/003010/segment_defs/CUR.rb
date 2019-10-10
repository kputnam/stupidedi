# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        CUR = s::SegmentDef.build(:CUR, "Currency",
          "To specify the currency (dollars, pounds, francs, etc) used in a
          transaction",
          e::E98  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E100 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E280 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

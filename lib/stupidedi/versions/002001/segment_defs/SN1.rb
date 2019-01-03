# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @note: Definition might be outdated, working from ANSI X12 2001 specification
        SN1 = s::SegmentDef.build(:SN1, "Item Detail (Shipment)",
          "To specify line-item detail relative to shipment",
          e::E350 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E382 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E646 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E330 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E728 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E668 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

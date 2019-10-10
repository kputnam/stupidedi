# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        PO1 = s::SegmentDef.build(:PO1, "Purchase Order Baseline Item Data",
          "To specify basic and most frequently used purchase order line item
          data",
          e::E350 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E330 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E212 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E639 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

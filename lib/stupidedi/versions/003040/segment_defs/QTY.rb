# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        QTY = s::SegmentDef.build(:QTY, "Quantity",
          "To specify quantity information",
          e::E673 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

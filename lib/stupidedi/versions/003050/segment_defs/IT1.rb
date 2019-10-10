# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        IT1 = s::SegmentDef.build(:IT1, "Baseline Item Data (Invoice)",
          "To specify the basic and most frequently used line item data for the
          invoice and related transactions",
          e::E350 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E358 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E212 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

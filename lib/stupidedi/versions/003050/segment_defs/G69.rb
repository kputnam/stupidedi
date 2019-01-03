# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        G69 = s::SegmentDef.build(:G69, "Line Item Detail - Description",
          "To describe an item in free-form format",
          e::E369 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

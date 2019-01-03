# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        PRR = s::SegmentDef.build(:PRR, "Problem Report",
          "To describe a product condition when presented for service or a
          recall notice or a service bulletin",
          e::E350 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E248 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E248 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1229.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E352 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

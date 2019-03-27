# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @note: Definition might be outdated, working from ANSI X12 2001 specification
        TD1 = s::SegmentDef.build(:TD1, "Carrier Details (Quantity and Weight)",
          "To specify the transportation details relative to commodity, weight,
          and quantity",
          e::E103 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E80  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E23  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E22  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E79  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E187 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

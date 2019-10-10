# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        L7  = s::SegmentDef.build(:L7, "Tariff Reference",
          "To reference details of the tariff used to arrive at applicable rates
          or charges",
          e::E213 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E168 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E171 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E172 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E169 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E170 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E59  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E173 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E46  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E119 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E227 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E294 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E295 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E19  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E156 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

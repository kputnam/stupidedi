# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        W14 = s::SegmentDef.build(:W14, "Total Receipt Information",
          "To indicate total received quantity",
          e::E380.simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
          e::E380.simple_use(r::Optional,    s::RepeatCount.bounded(1)),
          e::E380.simple_use(r::Optional,    s::RepeatCount.bounded(1)),
          e::E380.simple_use(r::Optional,    s::RepeatCount.bounded(1)),
          e::E380.simple_use(r::Optional,    s::RepeatCount.bounded(1)))
      end
    end
  end
end

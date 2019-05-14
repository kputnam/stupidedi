# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        R4  = s::SegmentDef.build(:R4, "Port or Terminal",
          "Contractual or operational port or point relevant to the movement of the cargo",
          e::E115 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E309 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E310 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E114 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
          e::E26  .simple_use(r::Optional,    s::RepeatCount.bounded(1)))
      end
    end
  end
end

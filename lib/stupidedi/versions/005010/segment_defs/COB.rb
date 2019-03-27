# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        COB = s::SegmentDef.build(:COB, "Coordination of Benefits",
          "To supply information on coordination of benefits",
          e::E1138.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1143.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1365.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

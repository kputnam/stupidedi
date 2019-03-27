# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        TRN = s::SegmentDef.build(:TRN, "Trace",
          "To uniquely identify a transaction to an application",
          e::E481 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E509 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

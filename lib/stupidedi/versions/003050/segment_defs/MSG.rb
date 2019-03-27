# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MSG = s::SegmentDef.build(:MSG, "Message Text",
          "To provide a free form format that would allow the transmission of
          text information",
          e::E933 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

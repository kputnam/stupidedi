# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        LX  = s::SegmentDef.build(:LX, "Assigned Numbers",
          "To reference a line number in a transaction set",
          e::E554.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

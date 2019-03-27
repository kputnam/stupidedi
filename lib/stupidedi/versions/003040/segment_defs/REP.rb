# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        REP = s::SegmentDef.build(:REP, "Repair Action",
          "To specify the action that was taken or is to be taken in response to
          a service request",
          e::E350 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

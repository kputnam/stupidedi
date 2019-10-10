# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        N4  = s::SegmentDef.build(:N4, "Geographic Location",
          "To specify the goegraphic place of the named party",
          e::E19  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E156 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E116 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E26  .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

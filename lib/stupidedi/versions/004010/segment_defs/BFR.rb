# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        BFR = s::SegmentDef.build(:BFR, "Beginning Segment for Planning Schedule",
          "To indicate the beginning of a planning schedule transaction set;
          whether a ship or delivery based forecast; and related forecast
          envelope dates",
          e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E328 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E675 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E676 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E367 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E367 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E324 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

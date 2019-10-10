# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        SDP = s::SegmentDef.build(:SDP, "Ship/Delivery Pattern",
          "To identify specific ship/delivery requirements",
          e::E678 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E679 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

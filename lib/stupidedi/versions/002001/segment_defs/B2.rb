# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        B2  = s::SegmentDef.build(:B2, "Beginning Segment for Shipment Information Transaction",
          "To transmit basic data relating to shipment information",
          e::E375 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E140 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E154 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E145 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E188 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E146 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E147 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E86  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E460 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E501 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E335 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E591 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

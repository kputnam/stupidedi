# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          B1 = s::SegmentDef.build(:B1, "Beginning Segment for Booking or Pick-up/Delivery",
            "To transmit identifying numbers, dates, and other basic data relating to the transaction set",
            e::E140 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E145 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E558 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

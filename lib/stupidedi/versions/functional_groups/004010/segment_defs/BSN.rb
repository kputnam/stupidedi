# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BSN = s::SegmentDef.build(:BSN, "Beginning Segment for Ship Notice",
            "To transmit identifying numbers, dates, and other basic data relating to the transaction set",
            e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E396 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1005.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          B3 = s::SegmentDef.build(:B3, "Beginning Segment for Carrier's Invoice",
            "To transmit basic data relating to the carrier's invoice",
            e::E147 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E76 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E145 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E146 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E193 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E202  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E32 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E374 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E140 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

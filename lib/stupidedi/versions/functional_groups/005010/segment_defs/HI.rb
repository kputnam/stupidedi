# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          HI = s::SegmentDef.build(:HI, "Health Care Information Codes",
            "To supply information related to the delivery of health care",
            e::C022 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::C022 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C022 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

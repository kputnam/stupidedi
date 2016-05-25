# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BGN = s::SegmentDef.build(:BGN, "Beginning Segment",
            "To indicate the beginning of a transaction set",
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end


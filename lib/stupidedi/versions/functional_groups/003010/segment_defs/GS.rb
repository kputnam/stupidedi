# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          GS = s::SegmentDef.build(:GS, "Functional Group Header",
            "To indicate the beginning of a functional group and to provider control information",
            e::E479 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E142 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E124 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E28  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E455 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E480 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

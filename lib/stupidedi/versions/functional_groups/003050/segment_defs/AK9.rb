# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AK9 = s::SegmentDef.build(:AK9, "Functional Group Response Trailer",
            "To acknowledge acceptance or rejection of a functional group and report the number of included transaction sets from the original trailer, the accepted sets, and the received sets in this functional group",
            e::E715 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E97  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E123 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E2   .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E716 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end


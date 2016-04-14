# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AK1 = s::SegmentDef.build(:AK1, "Functional Group Response Header",
            "To start acknowledgement of a functional group",
            e::E479 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E28  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

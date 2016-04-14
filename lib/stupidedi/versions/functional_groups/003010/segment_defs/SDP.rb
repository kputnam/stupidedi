# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          # Definition might be outdated, working from ANSI X12 2001 specification
          SDP = s::SegmentDef.build(:SDP, "Ship/Delivery Pattern",
            "To identify specific ship/delivery requirements",
            e::E678.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E679.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

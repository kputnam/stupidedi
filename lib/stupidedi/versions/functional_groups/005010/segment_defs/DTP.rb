# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          DTP = s::SegmentDef.build(:DTP, "Date or Time Period",
            "To specify any or all of a date, or a time period",
            e::E374 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1250.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1251.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

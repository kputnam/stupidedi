# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

#(insurance) Maintenance Type Code
# Blank
# Health Insruance Indicator
# A description or number that identifies the plan or coverage*COVERAGE TYPE CODE (Employee+Spouse)

          HD = s::SegmentDef.build(:HD, "Plan information",
            "Information about the insured",
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end


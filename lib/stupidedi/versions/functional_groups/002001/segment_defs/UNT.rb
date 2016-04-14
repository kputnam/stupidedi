# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          UNT = s::SegmentDef.build(:UNT, "Unit of Measure",
            "To ....",
            e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

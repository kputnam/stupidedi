# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CL1 = s::SegmentDef.build(:CL1, "Claim Codes",
            "To supply information specific to hopsital claims",
            e::E1315.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1314.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1352.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1345.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

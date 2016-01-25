# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CLP = s::SegmentDef.build(:CLP, "Claim Level Data",
            "To supply information common to all services of a claim",
            e::E1028.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1029.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1032.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1331.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1325.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1352.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1354.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E954 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

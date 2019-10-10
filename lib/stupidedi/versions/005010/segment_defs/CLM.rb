# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        CLM = s::SegmentDef.build(:CLM, "Health Claim",
          "To specify basic data about the claim",
          e::E1028.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1032.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1343.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C023 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1359.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1363.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1351.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C024 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1366.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1338.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1360.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1029.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1383.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1514.simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

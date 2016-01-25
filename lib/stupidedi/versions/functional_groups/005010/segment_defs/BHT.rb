# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BHT = s::SegmentDef.build(:BHT, "Beginning of Hierarchical Transaction",
            "To define the business hierarchical structure of the transaction set and identify the business application purpose and reference data, i.e., number, date, and time",
            e::E1005.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E640 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

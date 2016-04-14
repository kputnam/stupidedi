# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SVD = s::SegmentDef.build(:SVD, "Service Line Adjustment",
            "To convey service line adjudication information for coordination of benefits between the initial payers of a health care claim and all subsequent payers",
            e::E67  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::C003 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E554 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

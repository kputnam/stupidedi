module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AK2 = s::SegmentDef.build(:AK2, "Transaction Set Response Header",
            "To start acknowledgement of a single transaction set",
            e::E143 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E329 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end


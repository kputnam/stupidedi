# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs 

          ST = s::SegmentDef.build(:ST, "Transaction Set Header",
            "To indicate the start of a transaction set and assign a control number",
            e::E143 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E329 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

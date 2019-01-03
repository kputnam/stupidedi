# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        K1  = s::SegmentDef.build(:K1 , "Remarks",
          "To transmit information in a free-form format for comment or special
          instruction",
          e::E61  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E61  .simple_use(r::Optional ,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

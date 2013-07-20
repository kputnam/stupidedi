module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

        # Definition might be outdated, working from ANSI X12 2001 specification
        
          BSN = s::SegmentDef.build(:BSN, "Beginning Segment for Ship Notice",
            "To transmit identifying numbers, dates, and other basic data relating to the transaction set",
            e::E353.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E396.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E729.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)), #E373 ?
            e::E730.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1005.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E640.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E641.simple_use(r::Optional,   s::RepeatCount.bounded(1))) 

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs 

        # Definition might be outdated, working from ANSI X12 2001 specification
        
          PO4 = s::SegmentDef.build(:PO4, "Item Physical Details",
            "To specify the physical qualities, packaging, weights, and dimensions relating to the item",
            e::E356 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E357 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

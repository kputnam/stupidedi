module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs 

        # Definition might be outdated, working from ANSI X12 2001 specification
        
          TD1 = s::SegmentDef.build(:TD1, "Carrier Details (Quantity and Weight)",
            "To specify the transportation details relative to commodity, weight, and quantity",
            e::E103 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E80  .simple_use(r::Relational,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

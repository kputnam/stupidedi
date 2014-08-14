module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen 
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs
          
          #This is a custom segment specific to Just Suspensions
          CSH = s::SegmentDef.build(:CSH, "Sales Requirements",
            "To specify general conditions or requirements of the sale",
            e::E563.simple_use(r::Optional,    s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end


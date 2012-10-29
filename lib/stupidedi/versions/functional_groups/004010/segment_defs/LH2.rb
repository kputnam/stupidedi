module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LH2 = s::SegmentDef.build(:LH2, "Hazardous Classification Information",
            "To specify the hazadous notation and endorsement information",
            e::E215.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E983.simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

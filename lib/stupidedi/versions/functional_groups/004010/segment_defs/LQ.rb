module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LQ = s::SegmentDef.build(:LQ, "Industry Code Identification",
            "To identify standard industry codes",
            e::E1270.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E1271.simple_use(r::Mandatory, s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end

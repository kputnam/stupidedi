module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W20 = s::SegmentDef.build(:W20, "Pack Detail",
            "Pack Detail",
            e::E356.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E357.simple_use(r::Mandatory,  s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

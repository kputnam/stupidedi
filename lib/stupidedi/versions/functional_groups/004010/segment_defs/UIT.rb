module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          UIT = s::SegmentDef.build(:UIT, "Unit Detail",
            "To specify item unit data", 
            e::C001 .simple_use(r::Relational, s::RepeatCount.bounded(1)),          
            e::E212 .simple_use(r::Relational, s::RepeatCount.bounded(1))
            )

        end
      end
    end
  end
end
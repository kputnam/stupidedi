module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W14 = s::SegmentDef.build(:W14, "Total Receipt Information",
            "To indicate total received quantity",
            e::E413.simple_use(r::Mandatory,  s::RepeatCount.bounded(1))
          )
        end
      end
    end
  end
end


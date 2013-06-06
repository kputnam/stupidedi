module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          S5  = s::SegmentDef.build(:S5 , "Stop Off Details",
            "To specify stop-off detail reference numbers and stop reason",
            e::E165.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E163.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

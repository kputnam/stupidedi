module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          JIT = s::SegmentDef.build(:JIT, "Just-In-Time Schedule",
            "To identify the specific shipping/delivery time in terms of a 24-hour clock and identify the associated quantity",
            e::E380 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

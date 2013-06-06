module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LFH = s::SegmentDef.build(:LFH, "Hazardous Material Shipping Name",
            "To specify the hazardous material shipping name and additional descriptive requirements",
            e::E808.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E809.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

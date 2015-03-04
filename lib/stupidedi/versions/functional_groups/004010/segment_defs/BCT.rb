module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BCT = s::SegmentDef.build(:BCT, "Beginning Segment for Price/Sales Catalog",
            "To indicate the beginning of the Price/Sales Catalog Transaction Set and specify catalog purpose and number information",
            e::E683 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

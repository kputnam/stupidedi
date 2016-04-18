module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SLN = s::SegmentDef.build(:SLN, "Subline Item Details",
            "To specify product subline detail item data",
            e::E350 .simple_use(r::Required,   s::RepeatCount.bounded(1)),
            e::E662 .simple_use(r::Required,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Required,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Required,   s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Required,   s::RepeatCount.bounded(1)))
            e::E234 .simple_use(r::Required,   s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end

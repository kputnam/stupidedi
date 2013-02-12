module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W01 = s::SegmentDef.build(:W01, "Line Item Detail",
            "Line Item Detail",
            e::E330.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E355.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E438.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E235.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E235.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E234.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E451.simple_use(r::Optional, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

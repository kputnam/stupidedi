module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W12 = s::SegmentDef.build(:W12, "Warehouse Item Detail",
            "To designate those line items that were shipped.",
            e::E368.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E382.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E355.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E235.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E187.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E187.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E235.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E235.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234.simple_use(r::Relational, s::RepeatCount.bounded(1))

          )
        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W76 = s::SegmentDef.build(:W76, "Total Shipping Order",
            "Total Shipping Order",
            e::E330.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E81.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E355.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E183.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E355.simple_use(r::Relational, s::RepeatCount.bounded(1))
          )
        end
      end
    end
  end
end


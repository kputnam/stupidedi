module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W27 = s::SegmentDef.build(:W27, "Carrier Detail",
            "To specify details of the transportation equipment and carrier routing details",
            e::E91.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E140.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E146.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E206.simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E207.simple_use(r::Optional, s::RepeatCount.bounded(1))
          )
        end
      end
    end
  end
end

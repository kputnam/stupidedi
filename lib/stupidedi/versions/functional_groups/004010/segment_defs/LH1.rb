module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LH1 = s::SegmentDef.build(:LH1, "Hazardous Identification Information",
            "To specify the hazardous commodity identification reference number and quantity",
            e::E355.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E80 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E277.simple_use(r::Optional ,  s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E254.simple_use(r::Optional ,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

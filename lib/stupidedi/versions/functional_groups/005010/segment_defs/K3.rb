module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          K3 = s::SegmentDef.build(:K3, "File Information",
            "To transmit a fixed-format record or matrix contents",
            e::E449 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1333.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C001 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

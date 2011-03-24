module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CRC = s::SegmentDef.build(:CRC, "Conditions Indicator",
            "To supply information on conditions",
            e::E1136.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E1321.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E1321.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E1321.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E1321.simple_use(r::Optional,  s::RepeatCount.bounded(1)),

            e::E1321.simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CRC = SegmentDef.build :CRC, "Conditions Indicator",
            "To supply information on conditions",
            E::E1136.simple_use(Mandatory, RepeatCount.bounded(1)),
            E::E1073.simple_use(Mandatory, RepeatCount.bounded(1)),
            E::E1321.simple_use(Mandatory, RepeatCount.bounded(1)),
            E::E1321.simple_use(Optional,  RepeatCount.bounded(1)),
            E::E1321.simple_use(Optional,  RepeatCount.bounded(1)),
            E::E1321.simple_use(Optional,  RepeatCount.bounded(1)),

            E::E1321.simple_use(Optional,  RepeatCount.bounded(1))

        end
      end
    end
  end
end

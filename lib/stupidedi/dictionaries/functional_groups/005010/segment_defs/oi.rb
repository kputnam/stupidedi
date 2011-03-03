module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          OI = SegmentDef.build :OI, "Other Health Insurance Information",
            "To specify information associated with other health insurance coverage",
            E::E1032.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1383.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1351.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1360.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1363.simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

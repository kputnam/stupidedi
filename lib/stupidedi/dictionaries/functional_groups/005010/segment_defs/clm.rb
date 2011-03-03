module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          CLM = SegmentDef.new \
            :CLM, "Health Claim",
            "To specify basic data about the claim",
            E::E1028.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1032.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1343.simple_use(Optional,   RepeatCount.bounded(1)),
            E::C023 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),

            E::E1359.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1363.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1351.simple_use(Optional,   RepeatCount.bounded(1)),
            E::C024 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1366.simple_use(Optional,   RepeatCount.bounded(1)),

            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1338.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1360.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1029.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),

            E::E1383.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1514.simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          SBR = SegmentDef.new \
            :SBR, "Subscriber Information",
            "To record information specific to the primary insured and the insurance carrier for that insured",
            E::E1138.simple_use(Mandatory, RepeatCount.bounded(1)),
            E::E1069.simple_use(Optional,  RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,  RepeatCount.bounded(1)),
            E::E93  .simple_use(Optional,  RepeatCount.bounded(1)),
            E::E1336.simple_use(Optional,  RepeatCount.bounded(1)),
            E::E1143.simple_use(Optional,  RepeatCount.bounded(1)),

            E::E1073.simple_use(Optional,  RepeatCount.bounded(1)),
            E::E584 .simple_use(Optional,  RepeatCount.bounded(1)),
            E::E1032.simple_use(Optional,  RepeatCount.bounded(1))

        end
      end
    end
  end
end

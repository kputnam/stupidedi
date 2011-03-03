module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          CL1 = SegmentDef.new \
            :CL1, "Claim Codes",
            E::E1315.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1314.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1352.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1345.simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

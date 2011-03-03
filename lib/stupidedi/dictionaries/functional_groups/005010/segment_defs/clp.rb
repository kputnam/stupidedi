module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          CLP = SegmentDef.new \
            :CLP, "Claim Level Data",
            E::E1028.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1029.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1032.simple_use(Optional,   RepeatCount.bounded(1)),

            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1331.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1325.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1352.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1354.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E954 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

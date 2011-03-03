module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          DN2 = SegmentDef.new \
            :DN2, "Tooth Summary",
            E::E127 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1368.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1250.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1251.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1270.simple_use(Mandatory,  RepeatCount.bounded(1))

        end
      end
    end
  end
end

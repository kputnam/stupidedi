module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          RDM = SegmentDef.new \
            :RDM, "Remittance Delivery Method",
            E::E756 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E93  .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E364 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C040 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C040 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

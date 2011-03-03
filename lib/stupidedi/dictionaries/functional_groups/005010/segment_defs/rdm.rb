module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          RDM = SegmentDef.build :RDM, "Remittance Delivery Method",
            "To identify remittance delivery when remittance is separate from payment",
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

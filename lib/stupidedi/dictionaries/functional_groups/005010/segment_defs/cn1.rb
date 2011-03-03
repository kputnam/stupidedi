module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          CN1 = SegmentDef.build :CN1, "Contract Information",
            "To specify basic data about the contract or contract line item",
            E::E1166.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E332 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E338 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E799 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

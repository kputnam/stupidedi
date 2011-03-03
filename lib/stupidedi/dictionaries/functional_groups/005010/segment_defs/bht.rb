module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          BHT = SegmentDef.new \
            :BHT, "Beginning of Hierarchical Transaction",
            "To define the business hierarchical structure of the transaction set and identify the business application purpose and reference data, i.e., number, date, and time",
            E::E1005.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E353 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E373 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E337 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E640 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

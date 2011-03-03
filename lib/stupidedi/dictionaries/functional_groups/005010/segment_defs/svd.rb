module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          SVD = SegmentDef.new \
            :SVD, "Service Line Adjustment",
            "To convey service line adjudication information for coordination of benefits between the initial payers of a health care claim and all subsequent payers",
            E::E67  .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C003 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E234 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E554 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          MOA = SegmentDef.new \
            :MOA, "Medicare Outpatient Adjudication",
            "To convey claim-level data related to the adjudication of Medicare claims not related to an inpatient setting",
            E::E954 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

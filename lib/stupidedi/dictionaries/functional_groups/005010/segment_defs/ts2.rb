module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          TS2 = SegmentDef.new \
            :TS2, "Transaction Supplemental Statistics",
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

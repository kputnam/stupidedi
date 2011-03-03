module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          MIA = SegmentDef.new \
            :MIA, "Medicare Inpatient Adjudication",
            E::E380 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          BPR = SegmentDef.new \
            :BPR, "Financial Information",
            E::E305 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E478 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E591 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E812 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E506 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E507 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E569 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E508 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E509 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E510 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E506 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E507 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E569 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E508 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1048.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E506 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E507 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E569 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E508 .simple_use(Relational, RepeatCount.bounded(1))

        end
      end
    end
  end
end

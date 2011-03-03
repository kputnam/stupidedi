module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          PLB = SegmentDef.new \
            :PLB, "Provider Level Adjustment",
            E::E127 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E373 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C042 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1))

        end
      end
    end
  end
end

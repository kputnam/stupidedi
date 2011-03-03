module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          N1 = SegmentDef.new \
            :N1, "Party Identification",
            E::E98  .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E93  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E66  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E67  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E706 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E98  .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

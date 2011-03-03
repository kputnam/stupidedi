module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          TOO = SegmentDef.new \
            :TOO, "Tooth Identification",
            "To identify a tooth by number and, if applicable, one or more tooth surfaces",
            E::E1270.simple_use(Relational, RepeatCount.bounded(1)),
            E::E1271.simple_use(Relational, RepeatCount.bounded(1)),
            E::C005 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          AMT = SegmentDef.new \
            :AMT, "Monetary Amount Information",
            "To indicate the total monetary amount",
            E::E522 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E478 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

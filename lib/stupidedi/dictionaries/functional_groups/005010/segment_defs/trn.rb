module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          TRN = SegmentDef.new \
            :TRN, "Trace",
            E::E481 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E127 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E509 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          LX = SegmentDef.new \
            :LX, "Transaction Set Line Number",
            "To reference a line number in a transaction set",
            E::E554 .simple_use(Mandatory,  RepeatCount.bounded(1))

        end
      end
    end
  end
end

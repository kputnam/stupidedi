module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          ST = SegmentDef.new \
            :ST, "Transaction Set Header",
            "To indicate the start of a transaction set and assign a control number",
            E::E143 .simple_use(Mandatory,  RepeatCount.bound(1)),
            E::E329 .simple_use(Mandatory,  RepeatCount.bound(1)),
            E::E1705.simple_use(Optional,   RepeatCount.bound(1))

        end
      end
    end
  end
end

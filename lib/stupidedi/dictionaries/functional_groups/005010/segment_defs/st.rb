module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          ST = SegmentDef.build :ST, "Transaction Set Header",
            "To indicate the start of a transaction set and assign a control number",
            E::DE143 .simple_use(Mandatory,  RepeatCount.bound(1)),
            E::DE329 .simple_use(Mandatory,  RepeatCount.bound(1)),
            E::DE1705.simple_use(Optional,   RepeatCount.bound(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          SE = SegmentDef.build :SE, "Transaction Set Trailer",
            "To indicate the end of the transaction set and provide the count of the transmitted segments (including the beginning (ST) and ending (SE) segments)",
            E::E96  .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E329 .simple_use(Mandatory,  RepeatCount.bounded(1))

        end
      end
    end
  end
end

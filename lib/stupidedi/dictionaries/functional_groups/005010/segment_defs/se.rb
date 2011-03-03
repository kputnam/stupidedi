module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SE = s::SegmentDef.build(:SE, "Transaction Set Trailer",
            "To indicate the end of the transaction set and provide the count of the transmitted segments (including the beginning (ST) and ending (SE) segments)",
            e::E96  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E329 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

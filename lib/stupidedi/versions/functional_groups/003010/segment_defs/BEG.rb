module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BEG = s::SegmentDef.build(:BEG, "Beginning Segment for Purchase Order",
            "To indicate the beginning of the Purchase Order Transaction Set and transmit identifying numbers and dates",
            e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E92  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E324 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E328 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E367 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E587 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1019.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1166.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1232.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E786 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E640 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

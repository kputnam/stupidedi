module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          RMT  = s::SegmentDef.build(:RMT , "Remittance Advice",
            "To indicate the detail on items",
            e::E128 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E777 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E0 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E0 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E780 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E0 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E426 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end

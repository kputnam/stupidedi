module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CN1 = s::SegmentDef.build(:CN1, "Contract Information",
            "To specify basic data about the contract or contract line item",
            e::E1166.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E332 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E338 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E799 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

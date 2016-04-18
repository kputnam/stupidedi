module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PRF = s::SegmentDef.build(:PRF, "Purchase Order Reference",
            "Contains data about the purchase order being filled by this ASN",
            e::E324.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E328.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end

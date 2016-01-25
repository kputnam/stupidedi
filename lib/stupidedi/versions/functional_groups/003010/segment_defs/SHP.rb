# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          SHP = s::SegmentDef.build(:SHP, "Shipped/ReceivedInformationhip/Delivery Pattern",
            "",
            e::E673 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E374 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Relational,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

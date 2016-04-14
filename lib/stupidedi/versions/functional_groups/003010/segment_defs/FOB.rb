# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          FOB = s::SegmentDef.build(:FOB, "F.O.B. Related Instructions",
            "To specify transportation instructions relating to shipment",
            e::E146 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E309 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E309 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

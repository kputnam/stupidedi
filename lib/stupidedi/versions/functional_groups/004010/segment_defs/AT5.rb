# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AT5 = s::SegmentDef.build(:AT5, "Shipment Special Handling",
            "To specify shipment special handling",
            e::E152 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E80  .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E153 .simple_use(r::Relational, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

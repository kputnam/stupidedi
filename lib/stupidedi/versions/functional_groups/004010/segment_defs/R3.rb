# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          R3 = s::SegmentDef.build(:R3, "Route Information - Motor",
            "To specify carrier and routing sequences and details.",
            e::E140 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E133 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E19 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E91 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E154 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E76 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E610 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E369 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

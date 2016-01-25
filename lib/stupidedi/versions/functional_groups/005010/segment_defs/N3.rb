# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N3 = s::SegmentDef.build(:N3, "Party Location",
            "To specify the location of the named party",
            e::E166 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E166 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

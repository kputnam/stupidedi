# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        B2A = s::SegmentDef.build(:B2A, "Set Purpose",
          "To allow for positive identification of transaction set purpose",
          e::E353 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E346 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

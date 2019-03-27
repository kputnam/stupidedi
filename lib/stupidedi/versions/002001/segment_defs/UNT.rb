# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        UNT = s::SegmentDef.build(:UNT, "Unit of Measure",
          "",
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

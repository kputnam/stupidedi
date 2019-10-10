# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @note: Definition might be outdated, working from ANSI X12 2001 specification
        UIT = s::SegmentDef.build(:UIT, "Unit Detail",
          "To specify item unit data",
          e::E355.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E212.simple_use(r::Optional,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

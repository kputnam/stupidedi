# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MPI = s::SegmentDef.build(:MPI, "Military Personnel Information",
          "To report military service data",
          e::E1201.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E584 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1595.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E353 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1596.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1250.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1251.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(6, 7))
      end
    end
  end
end

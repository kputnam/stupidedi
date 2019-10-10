# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        III = s::SegmentDef.build(:III, "Information",
          "To report information",
          e::E1270.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1271.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1136.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E933 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C001 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E752 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E752 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E752 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(1, 2),
          SyntaxNotes::L.build(3, 4, 5))
      end
    end
  end
end

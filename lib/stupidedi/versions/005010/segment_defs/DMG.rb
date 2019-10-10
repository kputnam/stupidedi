# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        DMG = s::SegmentDef.build(:DMG, "Demographic Information",
          "To supply demographic information",
          e::E1250.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1251.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1068.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1067.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::C056 .simple_use(r::Relational, s::RepeatCount.bounded(10)),
          e::E1066.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E26  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E659 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1270.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1271.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build( 1,  2),
          SyntaxNotes::P.build(10, 11),
          SyntaxNotes::C.build(11,  5))
      end
    end
  end
end

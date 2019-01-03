# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        NM1 = s::SegmentDef.build(:NM1, "Individual or Organizational Name",
          "To supply the full name of an individual or organizational entity",
          e::E98  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1065.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1035.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1036.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1037.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1038.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1039.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E66  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E67  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E706 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1035.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build( 8,  9),
          SyntaxNotes::C.build(11, 10),
          SyntaxNotes::C.build(12,  3))
      end
    end
  end
end

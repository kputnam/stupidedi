# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        LUI = s::SegmentDef.build(:LUI, "Language Use",
          "To specify language, type of usage, and proficiency or fluency",
          e::E66  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E67  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E352 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1303.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1476.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(1, 2),
          SyntaxNotes::L.build(4, 2, 3))
      end
    end
  end
end

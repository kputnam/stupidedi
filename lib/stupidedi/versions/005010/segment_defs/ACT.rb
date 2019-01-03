# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        ACT = s::SegmentDef.build(:ACT, "Account Identification",
          "To specify account information",
          e::E508 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E93  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E66  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E67  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E569 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E508 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E107 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1216.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(3, 4),
          SyntaxNotes::C.build(5, 6),
          SyntaxNotes::C.build(7, 5))
      end
    end
  end
end

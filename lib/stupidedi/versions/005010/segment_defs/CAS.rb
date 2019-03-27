# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        CAS = s::SegmentDef.build(:CAS, "Claims Adjustment",
          "To supply adjustment reason codes and amounts as needed for an entire
          claim or for a particular service within the claim being paid",
          e::E1033.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E1034.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E1034.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1034.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1034.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1034.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1034.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::L.build( 5,  6,  7),
          SyntaxNotes::C.build( 6,  5),
          SyntaxNotes::C.build( 7,  5),
          SyntaxNotes::L.build( 8,  9, 10),
          SyntaxNotes::C.build( 9,  8),
          SyntaxNotes::C.build(10,  8),
          SyntaxNotes::L.build(11, 12, 13),
          SyntaxNotes::C.build(12, 11),
          SyntaxNotes::C.build(13, 11),
          SyntaxNotes::L.build(14, 15, 16),
          SyntaxNotes::C.build(15, 14),
          SyntaxNotes::C.build(16, 14),
          SyntaxNotes::L.build(17, 18, 19),
          SyntaxNotes::C.build(18, 17),
          SyntaxNotes::C.build(19, 17))
      end
    end
  end
end

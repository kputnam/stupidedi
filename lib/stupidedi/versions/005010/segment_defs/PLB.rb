# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        PLB = s::SegmentDef.build(:PLB, "Provider Level Adjustment",
          "To convey provider level adjustment information for debit or credit
          transactions such as, accelerated payments, cost report settlements
          for a fiscal year, and timeliness report penalties unrelated to a
          specific claim or service",
          e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::C042 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::C042 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::C042 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::C042 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::C042 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::C042 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E782 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build( 5,  8),
          SyntaxNotes::P.build( 7,  8),
          SyntaxNotes::P.build( 9, 10),
          SyntaxNotes::P.build(11, 12),
          SyntaxNotes::P.build(13, 14))
      end
    end
  end
end

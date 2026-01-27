# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        TD5 = s::SegmentDef.build(:TD5, "Carrier Details (Routing Sequence/Transit Time)",
          "To specify the carrier and sequence of routing",
          e::E133.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E66 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E67 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E91 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E387.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E368.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E309.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E310.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E731.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E732.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E733.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E284.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E284.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E284.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E26 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::R.build(2, 4, 5, 6, 12),
          SyntaxNotes::C.build(2, 3),
          SyntaxNotes::C.build(7, 8),
          SyntaxNotes::C.build(10, 11),
          SyntaxNotes::C.build(13, 12),
          SyntaxNotes::C.build(14, 13),
          SyntaxNotes::C.build(15, 12))
      end
    end
  end
end

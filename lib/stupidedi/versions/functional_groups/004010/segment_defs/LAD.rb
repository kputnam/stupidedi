# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LAD = s::SegmentDef.build(:LAD, "Lading Detail",
            "Order Identification Detail",
            e::E211 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E80  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E395 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E79  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1, 2),
            SyntaxNotes::P.build(3, 4),
            SyntaxNotes::P.build(5, 6),
            SyntaxNotes::P.build(7, 8),
            SyntaxNotes::P.build(9, 10),
            SyntaxNotes::P.build(11, 12))

        end
      end
    end
  end
end
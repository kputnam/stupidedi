module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CUR = s::SegmentDef.build(:CUR, "Currency",
            "To specify the currency (dollars, pounds, francs, etc) used in a transaction",
            e::E98  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E100 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E280 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
          
            # e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            # e::E100 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            # e::E669 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            # e::E374 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            # e::E337 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            # e::E374 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # e::E374 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E374 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # e::E374 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # SyntaxNotes::C.build( 8,  7),
            # SyntaxNotes::C.build( 9,  7),
            # SyntaxNotes::L.build(10, 11, 12),
            # SyntaxNotes::C.build(11, 10),
            # SyntaxNotes::C.build(12, 10),
            # SyntaxNotes::L.build(13, 14, 15),
            # SyntaxNotes::C.build(14, 13),
            # SyntaxNotes::C.build(15, 13),
            # SyntaxNotes::L.build(16, 17, 18),
            # SyntaxNotes::C.build(17, 16),
            # SyntaxNotes::C.build(18, 16),
            # SyntaxNotes::L.build(19, 20, 21),
            # SyntaxNotes::C.build(20, 19),
            # SyntaxNotes::C.build(21, 19))

        end
      end
    end
  end
end

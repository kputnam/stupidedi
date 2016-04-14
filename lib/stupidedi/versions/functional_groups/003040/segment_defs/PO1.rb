# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PO1 = s::SegmentDef.build(:PO1, "Purchase Order Baseline Item Data",
            "To specify basic and most frequently used purchase order line item data",
            e::E350 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E330 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E212 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E639 .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Optional, s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)))

            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # SyntaxNotes::C.build( 3,  2),
            # SyntaxNotes::C.build( 5,  4),
            # SyntaxNotes::P.build( 6,  7),
            # SyntaxNotes::P.build( 8,  9),
            # SyntaxNotes::P.build(10, 11),
            # SyntaxNotes::P.build(12, 13),
            # SyntaxNotes::P.build(14, 15),
            # SyntaxNotes::P.build(16, 17),
            # SyntaxNotes::P.build(18, 19),
            # SyntaxNotes::P.build(20, 21),
            # SyntaxNotes::P.build(22, 23),
            # SyntaxNotes::P.build(24, 25))
        end
      end
    end
  end
end

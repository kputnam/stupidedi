# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        W12 = s::SegmentDef.build(:W12, "Warehouse Item Detail",
          "To designate those line items that were shipped",
          e::E368 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E382 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E383 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E438 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E451 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E187 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E187 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E438 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E892 .simple_use(r::Optional  , s::RepeatCount.bounded(1)),
          e::E893 .simple_use(r::Optional  , s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::R.build( 6,  7),
          SyntaxNotes::P.build( 7,  8),
          SyntaxNotes::P.build(10, 11, 12),
          SyntaxNotes::P.build(13, 14, 15),
          SyntaxNotes::P.build(17, 18),
          SyntaxNotes::P.build(21, 22))
      end
    end
  end
end

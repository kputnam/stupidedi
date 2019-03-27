# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        W04 = s::SegmentDef.build(:W04, "Item Detail Total",
          "To designate those line items that were shipped",
          e::E382 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E438 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E59  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E121 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E23  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E22  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E416 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E844 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::R.build( 3,  4),
          SyntaxNotes::P.build( 4,  5),
          SyntaxNotes::P.build( 6,  7),
          SyntaxNotes::P.build(10, 11),
          SyntaxNotes::P.build(14, 15))
      end
    end
  end
end

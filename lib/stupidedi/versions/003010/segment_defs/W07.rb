# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        W07 = s::SegmentDef.build(:W07, "Item Detail For Stock Receipt",
          "To indicate quantity and condition of product received",
          e::E380 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E438 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E451 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E893 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          SyntaxNotes::R.build( 3,  4),
          SyntaxNotes::P.build( 4,  5),
          SyntaxNotes::P.build( 6,  7),
          SyntaxNotes::P.build(10, 11))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        L1  = s::SegmentDef.build(:L1, "Rate and Charges",
          "To specify rate and charges detail relative to a line item including
          freight charges, advances, special charges, and entitlements",
          e::E213 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E60  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E122 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E58  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E191 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E117 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E120 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E150 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E121 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E39  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E16  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E276 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E257 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E74  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E122 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E372 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E220 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E221 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E954 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::R.build(4, 5, 6),
          SyntaxNotes::P.build(2, 3),
          SyntaxNotes::P.build(14, 15),
          SyntaxNotes::P.build(17, 18))
      end
    end
  end
end

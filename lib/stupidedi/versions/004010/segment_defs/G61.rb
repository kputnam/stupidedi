# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        G61 = s::SegmentDef.build(:G61, "Contact",
          "To identify a person or office to whom communications should be
          directed",
          e::E366 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E93  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E365 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E364 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E443 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(3, 4))
      end
    end
  end
end

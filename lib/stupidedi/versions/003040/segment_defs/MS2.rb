# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyForty
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MS2 = s::SegmentDef.build(:MS2, "Equipment or Container Owner and Type",
          "To specify the owner, the identification number assigned by that
          owner, and the type of equipment",
          e::E140 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E207 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E40  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E761 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          SyntaxNotes::P.build(1, 2),
          SyntaxNotes::C.build(4, 2))
      end
    end
  end
end

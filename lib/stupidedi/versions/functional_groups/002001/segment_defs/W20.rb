# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W20 = s::SegmentDef.build(:W20, "Packing",
            "To specify packing details of the items shipped",
            e::E356 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E357 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E187 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E395 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E397 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(2, 3),
            SyntaxNotes::P.build(4, 5, 6),
            SyntaxNotes::P.build(8, 9))

        end
      end
    end
  end
end

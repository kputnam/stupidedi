module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          S5  = s::SegmentDef.build(:S5 , "Stop Off Details",
            "To specify stop-off detail reference numbers and stop reason",
            e::E165 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E163 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E382 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E184 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E154 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E190 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(3, 4),
            SyntaxNotes::P.build(5, 6),
            SyntaxNotes::P.build(7, 8))

        end
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PAT = s::SegmentDef.build(:PAT, "Patient Information",
            "To supply patient information",
            e::E1069.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1384.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E584 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1220.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1250.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1251.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(5, 6),
            SyntaxNotes::P.build(7, 8))

        end
      end
    end
  end
end

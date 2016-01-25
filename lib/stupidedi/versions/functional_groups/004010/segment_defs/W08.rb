# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W08 = s::SegmentDef.build(:W08, "Receipt Carrier Information",
            "To identify carrier equipment and condition.",
            e::E91  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E140 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E387 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E206 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E207 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E225 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E225 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E407 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E400 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(2, 4),
            SyntaxNotes::P.build(4, 5))

        end
      end
    end
  end
end


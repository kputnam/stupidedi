# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          L0 = s::SegmentDef.build(:L0, "Line Item - Quantity and Weight",
            "To specify quantity, weight, volume, and type of service for a line item including applicable 'quantity/rate-as' data",
            e::E213 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E220 .simple_use(r::Relational,   s::RepeatCount.bounded(1)),
            e::E221 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E81 .simple_use(r::Relational,   s::RepeatCount.bounded(1)),
            e::E187 .simple_use(r::Relational,   s::RepeatCount.bounded(1)),
            e::E183 .simple_use(r::Relational,   s::RepeatCount.bounded(1)),
            e::E184 .simple_use(r::Relational,   s::RepeatCount.bounded(1)),
            e::E80 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E211 .simple_use(r::Relational,   s::RepeatCount.bounded(1)),
            e::E188  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(2, 3),
            SyntaxNotes::P.build(2, 3),
            SyntaxNotes::P.build(4, 5),
            SyntaxNotes::P.build(6, 7),
            SyntaxNotes::P.build(8, 9))

        end
      end
    end
  end
end

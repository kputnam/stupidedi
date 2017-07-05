# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          L4 = s::SegmentDef.build(:L4, "Measurement",
            "To describe physical dimensions and quantities",
            e::E82 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E189 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E65 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E90 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            SyntaxNotes::P.build(1, 2, 3, 4, 5))

        end
      end
    end
  end
end

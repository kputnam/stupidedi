# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LH3 = s::SegmentDef.build(:LH3, "Hazardous Material Shipping Name",
            "To specify the hazardous material shipping name and additional descriptive requirements",
            e::E224 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E984 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E985 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,    s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1, 2))

        end
      end
    end
  end
end

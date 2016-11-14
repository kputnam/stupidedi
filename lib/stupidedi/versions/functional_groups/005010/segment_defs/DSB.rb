# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          DSB = s::SegmentDef.build(:DSB, "Disability Information",
            "To provide disability information",
            e::E1146.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1149.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1154.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1161.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1137.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(7, 8))

        end
      end
    end
  end
end


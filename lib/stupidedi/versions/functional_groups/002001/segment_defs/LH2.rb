# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LH2 = s::SegmentDef.build(:LH2, "Hazardous Classification Information",
            "To specify the hazadous notation and endorsement information",
            e::E215. simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E983. simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E218 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E222 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E759 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E408 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E408 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E408 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E188 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E267 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build( 6,  7),
            SyntaxNotes::P.build( 8,  9),
            SyntaxNotes::P.build(10, 11),
            SyntaxNotes::P.build(12, 13))

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          MEA = s::SegmentDef.build(:MEA, "Measurements",
            "To specify physical measurements or counts, including dimensions, tolerances, variances, and weights",
            e::E737 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E738 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E739 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E740 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E741 .simple_use(r::Relational, s::RepeatCount.bounded(1)))

          # SyntaxNotes::R.build( 3,  5,  6,  8),
          # SyntaxNotes::E.build( 4, 12),
          # SyntaxNotes::L.build( 5,  4, 12),
          # SyntaxNotes::L.build( 6,  4, 12),
          # SyntaxNotes::L.build( 7,  3,  5,  6),
          # SyntaxNotes::E.build( 8,  3),
          # SyntaxNotes::P.build(11, 12))

        end
      end
    end
  end
end

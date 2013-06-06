module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          MEA = s::SegmentDef.build(:MEA, "Measurements",
            "To specify physical measurements or counts, including dimensions, tolerances, variances, and weights(See Figures Appendix for example of use of C001)",
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E999.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C001.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E740.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E741.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::C.build(3, 1),
            SyntaxNotes::C.build(4, 1),
            SyntaxNotes::R.build(3, 4))


        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          FRM = s::SegmentDef.build(:FRM, "Supporting Documentation",
            "To specify information in response to a codified questionnaire document",
            e::E350 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E332 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(2, 3, 4, 5))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          FRM = SegmentDef.build :FRM, "Supporting Documentation",
            "To specify information in response to a codified questionnaire document",
            E::E350 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1073.simple_use(Relational, RepeatCount.bounded(1)),
            E::E127 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E373 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E332 .simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::R.build(2, 3, 4, 5)

        end
      end
    end
  end
end

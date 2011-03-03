module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          HCP = SegmentDef.new :HCP, "Health Care Pricing",
            "To specify pricing or repricing information about a health care claim or line item",
            E::E1473.simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E118 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E127 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E234 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E235 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E901 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1526.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1527.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::R.new( 1, 13),
            SyntaxNote::P.new( 9, 10),
            SyntaxNote::P.new(11, 12)

        end
      end
    end
  end
end

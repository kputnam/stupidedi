module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          PLB = SegmentDef.new :PLB, "Provider Level Adjustment",
            "To convey provider level adjustment information for debit or credit transactions such as, accelerated payments, cost report settlements for a fiscal year, and timeliness report penalties unrelated to a specific claim or service",
            E::E127 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E373 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C042 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C042 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::P.new( 5,  8),
            SyntaxNote::P.new( 7,  8),
            SyntaxNote::P.new( 9, 10),
            SyntaxNote::P.new(11, 12),
            SyntaxNote::P.new(13, 14)

        end
      end
    end
  end
end

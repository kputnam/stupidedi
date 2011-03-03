module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          PRV = SegmentDef.new :PRV, "Provider Information",
            "To specify the identifying characteristics of a provider",
            E::E1221.simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E128 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E127 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E156 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C035 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1223.simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.new(2, 3)

        end
      end
    end
  end
end

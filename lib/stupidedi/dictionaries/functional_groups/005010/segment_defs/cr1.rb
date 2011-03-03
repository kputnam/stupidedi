module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          CR1 = SegmentDef.new \
            :CR1, "Ambulance Certification",
            "To supply information related to the ambulance service rendered to a patient",
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E81  .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1316.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1317.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),

            E::E166 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E166 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),

            SyntaxNote::P.new(1, 2),
            SyntaxNote::P.new(5, 6)

        end
      end
    end
  end
end

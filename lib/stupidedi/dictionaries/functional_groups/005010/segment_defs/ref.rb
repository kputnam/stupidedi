module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          REF = SegmentDef.new :REF, "Reference Information",
            "To specify identifying information",
            E::E128 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E127 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E352 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C040 .simple_use(Optional,   RepeatCount.bounded(1)),
            SyntaxNote.new(2, 3)

        end
      end
    end
  end
end

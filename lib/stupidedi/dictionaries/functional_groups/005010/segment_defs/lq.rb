module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          LQ = SegmentDef.new :LQ, "Industry Code Identification",
            "To identify standard industry codes",
            E::E1270.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1271.simple_use(Relational, RepeatCount.bounded(1)),

            SyntaxNote::C.new(1, 2)

        end
      end
    end
  end
end

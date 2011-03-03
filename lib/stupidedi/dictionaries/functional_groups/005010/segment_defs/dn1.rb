module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          DN1 = SegmentDef.build :DN1, "Orthodontic Information",
            "To supply orthodontic information",
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

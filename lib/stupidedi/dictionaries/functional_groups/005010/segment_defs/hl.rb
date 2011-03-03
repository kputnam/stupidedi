module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          HL = SegmentDef.build :HL, "Hierarchical Level",
            "To identify dependencies among the content of hierarchically related groups of data segments",
            E::E628 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E734 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E735 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E736 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          HI = SegmentDef.build :HI, "Health Care Information Codes",
            "To supply information related to the delivery of health care",
            E::C022 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),

            E::C022 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::C022 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

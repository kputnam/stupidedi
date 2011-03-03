module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          SV3 = SegmentDef.build :SV3, "Dental Service",
            "To specify the service line item detail for dental work",
            E::C003 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1331.simple_use(Optional,   RepeatCount.bounded(1)),
            E::C006 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1358.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E380 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1327.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1360.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::C004 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

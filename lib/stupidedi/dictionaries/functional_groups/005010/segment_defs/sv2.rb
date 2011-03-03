module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          SV2 = SegmentDef.new :SV2, "Institutional Service",
            "To specify the service line item detail for a health care institution",
            E::E234 .simple_use(Relational, RepeatCount.bounded(1)),
            E::C003 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E782 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E355 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E380 .simple_use(Relational, RepeatCount.bounded(1)),
            E::E1371.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E782 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1073.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1345.simple_use(Optional,   RepeatCount.bounded(1)),
            E::E1337.simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

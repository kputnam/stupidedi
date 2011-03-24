module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          IK4 = s::SegmentDef.build(:IK4, "Implementation Data Element Note",
            "To report implementation errors in a data element or composite data structure and identify the location of the data element",
            e::C030 .simple_use(r::Mandatory,  s::RepeatCount.bounded(10)),
            e::E725 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E621 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E724 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

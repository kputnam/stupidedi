module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          AK4 = s::SegmentDef.build(:AK4, "Data Segement Note",
            "To report errors in a data segment, and identify the location of a data segment.",
            e::C030 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E725 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E723 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E724 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

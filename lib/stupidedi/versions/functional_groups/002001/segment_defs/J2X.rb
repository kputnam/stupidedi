module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          J2X = s::SegmentDef.build(:J2X, "Item Description",
            "To ...",
            e::E349 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E349 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E372 .simple_use(r::Mandatory, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end


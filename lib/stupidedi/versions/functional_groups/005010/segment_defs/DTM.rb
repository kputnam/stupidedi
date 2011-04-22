module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          DTM = s::SegmentDef.build(:DTM, "Date/Time Reference",
            "To specify pertinent dates and times",
            e::E374 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E623 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1250.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1251.simple_use(r::Relational, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N1 = s::SegmentDef.build(:N1, "Party Identification",
            "To identify a party by type of organization, name, and code",
            e::E98  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E93  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E66  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E67  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E706 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

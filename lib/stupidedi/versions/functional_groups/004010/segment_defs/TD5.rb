module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          TD5 = s::SegmentDef.build(:TD5, "Carrier Details (Routing Sequence/Transit Time)",
            "To specify the carrier and sequence of routing and provide transit time information",
            e::E133.simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E66 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E67 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E91 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E387.simple_use(r::Optional,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

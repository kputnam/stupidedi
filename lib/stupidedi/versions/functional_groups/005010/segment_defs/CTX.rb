# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CTX = s::SegmentDef.build(:CTX, "Context",
            "Describes an event context in terms of the application or implementation context in force at the time the event occurred and the position in the EDI stream at which that context was activated",
            e::C998 .simple_use(r::Mandatory,  s::RepeatCount.bounded(10)),
            e::E721 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E719 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E447 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C030 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C999 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

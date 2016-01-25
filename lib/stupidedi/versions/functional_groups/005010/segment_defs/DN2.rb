# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          DN2 = s::SegmentDef.build(:DN2, "Tooth Summary",
            "To specify the status of individual teeth",
            e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E1368.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1250.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1251.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E1270.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

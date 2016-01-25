# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyForty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          REF = s::SegmentDef.build(:REF, "Reference Numbers",
            "To specify identifying information",
            e::E128 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Relational, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

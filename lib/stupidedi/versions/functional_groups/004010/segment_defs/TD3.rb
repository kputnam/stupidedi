# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

        # Definition might be outdated, working from ANSI X12 2001 specification

          TD3 = s::SegmentDef.build(:TD3, "Carrier Details (Equipment)",
            "To specify transportation details relating to the equipment used by the carrier",
            e::E40  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E206 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E207 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E187 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

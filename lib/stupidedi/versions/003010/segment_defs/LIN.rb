# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @note: Definition might be outdated, working from ANSI X12 2001 specification
        LIN = s::SegmentDef.build(:LIN, "Item Identification",
          "To specify basic item identification data",
          e::E350 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E235 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E234 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

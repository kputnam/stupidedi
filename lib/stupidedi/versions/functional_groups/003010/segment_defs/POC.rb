# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          POC = s::SegmentDef.build(:POC, "Line Item Change",
            "To specify changes to a line item",
            e::E350 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E670 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E330 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E671 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E212 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::E639 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E235 .simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E234 .simple_use(r::Optional,    s::RepeatCount.bounded(1)))
            # e::E786 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            # e::E640 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

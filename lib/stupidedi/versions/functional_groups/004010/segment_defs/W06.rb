# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          W06 = s::SegmentDef.build(:W06, "Warehouse Shipment Identification",
            "To provide identifying numbers, dates, and other basic data for this transaction set",
            e::E514 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E285 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E145 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E531 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E324 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E474 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E472 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E152 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E891 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E640 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E306 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(7, 8))

        end
      end
    end
  end
end

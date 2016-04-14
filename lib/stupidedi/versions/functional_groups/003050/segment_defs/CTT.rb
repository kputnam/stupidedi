# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CTT = s::SegmentDef.build(:CTT, "Transaction Totals",
            "To transmit a hash total for a specific element in the transaction set",
            e::E354 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
            # e::E347 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            # e::E81  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E183 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            # e::E352 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            # SyntaxNotes::P.build(3, 4),
            # SyntaxNotes::P.build(5, 6))

        end
      end
    end
  end
end

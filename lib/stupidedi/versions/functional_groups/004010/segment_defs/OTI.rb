# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          OTI = s::SegmentDef.build(:OTI, "Original Transaction Identification",
            "To identify the edited transaction set and the level at which the results of the edit are reported, and to indicate the accepted, rejected, or accepted-with-change edit result",
            e::E110 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E128 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E142 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E124 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E28  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E329 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E143 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E480 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E353 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E640 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E346 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E306 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E305 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E641 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::C.build(9, 8))

        end
      end
    end
  end
end


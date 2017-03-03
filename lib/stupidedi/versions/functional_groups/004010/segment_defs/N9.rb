# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N9  = s::SegmentDef.build(:N9 , "Reference Identification",
            "To transmit identifying information as specified by the Reference Identification Qualifier",
            e::E128 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E369 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E337 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E623 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            #e::C040 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(2, 3),
            SyntaxNotes::C.build(6, 5))

        end
      end
    end
  end
end

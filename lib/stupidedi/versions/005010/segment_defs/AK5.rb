# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        AK5 = s::SegmentDef.build(:AK5, "Transaction Set Response Trailer",
          "To acknowledge acceptance or rejection and report errors in a
          transaction set",
          e::E717 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E718 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E718 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E718 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E718 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E718 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

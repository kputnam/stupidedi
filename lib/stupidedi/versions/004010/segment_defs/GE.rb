# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        GE  = s::SegmentDef.build(:GE, "Functional Group Trailer",
          "To indicate the end of a functional group and provider control
          information",
          e::E97  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E28  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
      end
    end
  end
end

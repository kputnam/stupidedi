# frozen_string_literal: true
module Stupidedi
  module Versions
    module FortyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        AK3 = s::SegmentDef.build(:AK3, "Data Segement Note",
          "To report errors in a data segment, and identify the location of a
          data segment",
          e::E721 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E719 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E447 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
          e::E720 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

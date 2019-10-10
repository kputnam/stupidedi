# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        TOO = s::SegmentDef.build(:TOO, "Tooth Identification",
          "To identify a tooth by number and, if applicable, one or more tooth
          surfaces",
          e::E1270.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E1271.simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::C005 .simple_use(r::Optional,   s::RepeatCount.bounded(1)))
      end
    end
  end
end

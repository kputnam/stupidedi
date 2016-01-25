# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PRV = s::SegmentDef.build(:PRV, "Provider Information",
            "To specify the identifying characteristics of a provider",
            e::E1221.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E128 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E156 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C035 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1223.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(2, 3))

        end
      end
    end
  end
end

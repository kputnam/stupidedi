# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @todo
        IMM  = s::SegmentDef.build(:IMM, "Immunization Status", "")
      end
    end
  end
end

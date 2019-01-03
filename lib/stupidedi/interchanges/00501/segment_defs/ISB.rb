# frozen_string_literal: true
module Stupidedi
  module Interchanges
    module FiveOhOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @todo
        ISB = s::SegmentDef.build(:ISB, "Grade of Service Request", "")
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module Versions
    module FiftyTen
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        # @todo
        TXP = s::SegmentDef.build(:TXP, "Tax Payment", "")
      end
    end
  end
end

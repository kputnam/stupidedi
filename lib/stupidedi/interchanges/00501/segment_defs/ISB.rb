# frozen_string_literal: true
module Stupidedi
  module Versions
    module Interchanges
      module FiveOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FiftyTen::ElementReqs

          # @todo: Where's the documentation for this?
          ISB = s::SegmentDef.build(:ISB, "Grade of Service Request", "")

        end
      end
    end
  end
end

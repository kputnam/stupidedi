# frozen_string_literal: true
module Stupidedi
  module Versions
    module ThirtyFifty
      s = Schema
      r = ElementReqs

      FunctionalGroupDef = Class.new(Schema::FunctionalGroupDef) do
        # @return [FunctionalGroupVal]
        def empty
          Values::FunctionalGroupVal.new(self, [])
        end

        # @return [Module]
        def segment_dict
          SegmentDefs
        end
      end.new "003050",
        [ SegmentDefs::GS.use(1, r::Mandatory, s::RepeatCount.bounded(1)) ],
        [ SegmentDefs::GE.use(2, r::Mandatory, s::RepeatCount.bounded(1)) ]

    end
  end
end

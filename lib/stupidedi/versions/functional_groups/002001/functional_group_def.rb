# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module TwoThousandOne

        s = Schema
        r = ElementReqs

        # Singleton
        FunctionalGroupDef = Class.new(Schema::FunctionalGroupDef) do
          # @return [FunctionalGroupVal]
          def empty
            Values::FunctionalGroupVal.new(self, [])
          end

          # @return [Module]
          def segment_dict
            SegmentDefs
          end
        end.new "002001",
          # Functional group header
          [ SegmentDefs::GS.use(1, r::Mandatory, s::RepeatCount.bounded(1)) ],

          # Functional group trailer
          [ SegmentDefs::GE.use(2, r::Mandatory, s::RepeatCount.bounded(1)) ]

      end
    end
  end
end

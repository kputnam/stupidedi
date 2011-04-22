module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen

        s = Schema
        r = ElementReqs

        # Singleton
        FunctionalGroupDef = Class.new(Envelope::FunctionalGroupDef) do
          # @return [FunctionalGroupVal]
          def empty
            Envelope::FunctionalGroupVal.new(self, [])
          end

          # @return [Module]
          def segment_dict
            SegmentDefs
          end
        end.new "005010",
          # Functional group header
          [ SegmentDefs::GS.use(1, r::Mandatory, s::RepeatCount.bounded(1)) ],

          # Functional group trailer
          [ SegmentDefs::GE.use(2, r::Mandatory, s::RepeatCount.bounded(1)) ]

      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen

        s = Schema
        r = ElementReqs

        FunctionalGroupDef = Class.new(Envelope::FunctionalGroupDef) do
          # @return [FunctionalGroupVal]
          def empty(parent = nil)
            FunctionalGroupVal.new(self, [], [], [], parent)
          end

          # @return [FunctionalGroupVal]
          def value(header_segment_vals, transaction_set_vals, trailer_segment_vals, parent = nil)
            FunctionalGroupVal.new(self, header_segment_vals, trailer_segment_vals, trailer_segment_vals, parent)
          end

          def segment_dict
            Schema::SegmentDict.build(SegmentDefs)
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

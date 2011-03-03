module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        s = Schema
        r = FunctionalGroups::FiftyTen::ElementReqs

        InterchangeDef = Class.new(Envelope::InterchangeDef) do
          def empty
            FiveOhOne::InterchangeVal.new(self, [], [], [])
          end

          def value(header_segment_vals, functional_group_vals, trailer_segment_vals)
            FiveOhOne::InterchangeVal.new(self, header_segment_vals, functional_group_vals, trailer_segment_vals)
          end
        end.new "00501",
          # Header segment uses
          [ SegmentDefs::ISA.use(-950, r::Mandatory, s::RepeatCount.bounded(1)),
            SegmentDefs::ISB.use(-900, r::Optional,  s::RepeatCount.bounded(1)),
            SegmentDefs::ISE.use(-850, r::Optional,  s::RepeatCount.bounded(1)),
            SegmentDefs::TA1.use(-800, r::Optional,  s::RepeatCount.unbounded)
          ],

          # Trailer segment uses
          [ SegmentDefs::IEA.use(900, r::Mandatory, s::RepeatCount.bounded(1)) ]

      end
    end
  end
end

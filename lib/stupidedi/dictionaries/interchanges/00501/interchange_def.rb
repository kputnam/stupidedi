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

          def value(segment_val)
            FiveOhOne::InterchangeVal.new(self, segment_val.cons, [], [])
          end

          def segment_dict
            Schema::SegmentDict.build(SegmentDefs)
          end
        end.new "00501",
          # Interchange header
          [ SegmentDefs::ISA.use(-9050, r::Mandatory, s::RepeatCount.bounded(1)),
            SegmentDefs::ISB.use(-9040, r::Optional,  s::RepeatCount.bounded(1)),
            SegmentDefs::ISE.use(-9030, r::Optional,  s::RepeatCount.bounded(1)),
            SegmentDefs::TA1.use(-9020, r::Optional,  s::RepeatCount.unbounded) ],

          # Interchange trailer
          [ SegmentDefs::IEA.use(99000, r::Mandatory, s::RepeatCount.bounded(1)) ]

      end
    end
  end
end

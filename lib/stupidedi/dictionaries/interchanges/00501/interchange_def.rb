module Stupidedi
  module Dictionaries
    module Interchanges

      #
      # @see Envelope::InterchangeDef
      #
      module FiveOhOne

        s = Schema
        r = FunctionalGroups::FiftyTen::ElementReqs

        InterchangeDef = Class.new(Envelope::InterchangeDef) do
          # @group Constructors
          #####################################################################

          # @return [InterchangeVal]
          def empty
            FiveOhOne::InterchangeVal.new(self, [])
          end

          # @endgroup
          #####################################################################

          # @return [Module]
          def segment_dict
            SegmentDefs
          end

          # @return [Reader::Separators]
          def separators(isa)
            Reader::Separators.new(isa.element(16).to_s, isa.element(11).to_s, nil, nil)
          end
        end.new "00501",
          # Interchange header
          [ SegmentDefs::ISA.use(1, r::Mandatory, s::RepeatCount.bounded(1)),
            SegmentDefs::ISB.use(2, r::Optional,  s::RepeatCount.bounded(1)),
            SegmentDefs::ISE.use(3, r::Optional,  s::RepeatCount.bounded(1)),
            SegmentDefs::TA1.use(4, r::Optional,  s::RepeatCount.unbounded) ],

          # Interchange trailer
          [ SegmentDefs::IEA.use(5, r::Mandatory, s::RepeatCount.bounded(1)) ]

      end
    end
  end
end

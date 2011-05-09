module Stupidedi
  module Versions
    module Interchanges

      #
      # @see Values::InterchangeDef
      #
      module FourOhOne

        s = Schema
        r = FunctionalGroups::FortyTen::ElementReqs

        InterchangeDef = Class.new(Schema::InterchangeDef) do
          # @group Constructors
          #####################################################################

          # @return [Values::InterchangeVal]
          def empty
            Values::InterchangeVal.new(self, [])
          end

          # @endgroup
          #####################################################################

          # @return [Module]
          def segment_dict
            SegmentDefs
          end

          # @return [Reader::Separators]
          def separators(isa)
            Reader::Separators.new(isa.element(16).to_s, nil, nil, nil)
          end
        end.new "00401",
          # Interchange header
          [ SegmentDefs::ISA.use(1, r::Mandatory, s::RepeatCount.bounded(1)),
            SegmentDefs::TA1.use(4, r::Optional,  s::RepeatCount.unbounded) ],

          # Interchange trailer
          [ SegmentDefs::IEA.use(5, r::Mandatory, s::RepeatCount.bounded(1)) ]

      end
    end
  end
end

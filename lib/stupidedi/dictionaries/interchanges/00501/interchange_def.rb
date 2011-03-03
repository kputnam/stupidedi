module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne

        InterchangeDef = Class.new(Schema::InterchangeDef) do
          def copy(changes = {})
            raise NoMethodError, "@todo"
          end

          def id
            "00501"
          end

          def segment_uses
            @segment_uses ||=
              [ SegmentDefs::ISA.use(Mandatory, Schema::RepeatCount.bounded(1)),
                SegmentDefs::ISB.use(Optional,  Schema::RepeatCount.bounded(1)),
                SegmentDefs::ISE.use(Optional,  Schema::RepeatCount.bounded(1)),
                SegmentDefs::TA1.use(Optional,  Schema::RepeatCount.unbound),
                SegmentDefs::IEA.use(Mandatory, Schema::RepeatCount.bounded(1)) ]
          end

          def empty
            Envelope::InterchangeVal.new([], [], self)
          end

          def value(segment_vals, functional_group_vals = [])
            Envelope::InterchangeVal.new(segment_vals, functional_group_vals, self)
          end

          def reader(input, context)
            raise NoMethodError, "@todo"
          end
        end.new

      end
    end
  end
end

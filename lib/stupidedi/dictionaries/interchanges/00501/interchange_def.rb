module Stupidedi
  module Dictionaries
    module Interchange
      module FiveOhOne

        InterchangeDef = Class.new(Schema::InterchangeDef) do
          def id
            "00501"
          end

          def segment_uses
            @segment_uses ||=
              Array[ ISA.segment_use(Mandatory, RepepatCount.max(1)),
                     ISB.segment_use(Optional,  RepepatCount.max(1)),
                     ISE.segment_use(Optional,  RepepatCount.max(1)),
                     TA1.segment_use(Optional,  RepepatCount.unbound),
                     IEA.segment_use(Mandatory, RepeatCount.max(1)) ]
          end

          def value(segment_vals, functional_group_vals = [])
            InterchangeVal.new(self, segment_vals, functional_group_vals)
          end

          def empty
            InterchangeVal.new(self, [], [])
          end
        end.new

      end
    end
  end
end

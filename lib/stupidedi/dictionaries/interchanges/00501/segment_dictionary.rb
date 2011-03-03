module Stupiedi
  module Dictionaries
    module Interchange
      module FiveOhOne
        module SegmentDictionary

          ISA = SegmentDef.new \
            :ISA, "Interchange Control Header",
            I01.simple_use(Mandatory, RepeatCount.bounded(1)),
            I02.simple_use(Mandatory, RepeatCount.bounded(1)),
            I03.simple_use(Mandatory, RepeatCount.bounded(1)),
            I04.simple_use(Mandatory, RepeatCount.bounded(1)),
            I05.simple_use(Mandatory, RepeatCount.bounded(1)),
            I06.simple_use(Mandatory, RepeatCount.bounded(1)),
            I05.simple_use(Mandatory, RepeatCount.bounded(1)),
            I07.simple_use(Mandatory, RepeatCount.bounded(1)),
            I08.simple_use(Mandatory, RepeatCount.bounded(1)),
            I09.simple_use(Mandatory, RepeatCount.bounded(1)),
            I65.simple_use(Mandatory, RepeatCount.bounded(1)),
            I11.simple_use(Mandatory, RepeatCount.bounded(1)),
            I12.simple_use(Mandatory, RepeatCount.bounded(1)),
            I13.simple_use(Mandatory, RepeatCount.bounded(1)),
            I14.simple_use(Mandatory, RepeatCount.bounded(1)),
            I15.simple_use(Mandatory, RepeatCount.bounded(1))

          IEA = SegmentDef.new \
            :IEA, "Interchange Control Trailer",
            I16.simple_use(Mandatory, RepeatCount.bounded(1)),
            I12.simple_use(Mandatory, RepeatCount.bounded(1))

          TA1 = SegmentDef.new \
            :TA1, "Interchange Acknowledgement",
            I12.simple_use(Mandatory, RepeatCount.bounded(1)),
            I08.simple_use(Mandatory, RepeatCount.bounded(1)),
            I09.simple_use(Mandatory, RepeatCount.bounded(1)),
            I17.simple_use(Mandatory, RepeatCount.bounded(1)),
            I18.simple_use(Mandatory, RepeatCount.bounded(1))

        end
      end
    end
  end
end

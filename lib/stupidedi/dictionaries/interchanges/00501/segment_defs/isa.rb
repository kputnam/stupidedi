module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FiftyTen::ElementReqs

          ISA = s::SegmentDef.build \
            :ISA, "Interchange Control Header", "",
            e::I01.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I02.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I03.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I04.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I05.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I06.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I05.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I07.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I08.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I09.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I65.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I11.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I12.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I13.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I14.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I15.simple_use(r::Mandatory, s::RepeatCount.bounded(1))

        end
      end
    end
  end
end

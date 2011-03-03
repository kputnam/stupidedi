module Stupidedi
  module Dictionaries
    module Interchanges
      module FiveOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FiftyTen::ElementReqs

          IEA = s::SegmentDef.build \
            :IEA, "Interchange Control Trailer", "",
            e::I16.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I12.simple_use(r::Mandatory, s::RepeatCount.bounded(1))

        end
      end
    end
  end
end

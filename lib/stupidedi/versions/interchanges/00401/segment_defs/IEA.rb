module Stupidedi
  module Versions
    module Interchanges
      module FourOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FortyTen::ElementReqs

          IEA = s::SegmentDef.build(:IEA, "Interchange Control Trailer",
            "To define the end of an interchange of zero or more functional groups and interchange-related control segments",
            e::I16.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I12.simple_use(r::Mandatory, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

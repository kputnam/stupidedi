module Stupidedi
  module Versions
    module Interchanges
      module FiveOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FiftyTen::ElementReqs

          TA1 = s::SegmentDef.build(:TA1, "Interchange Acknowledgement",
            "",
            e::I12.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I08.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I09.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I17.simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::I18.simple_use(r::Mandatory, s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

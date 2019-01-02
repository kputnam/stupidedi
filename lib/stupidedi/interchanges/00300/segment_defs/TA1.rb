# frozen_string_literal: true
module Stupidedi
  module Versions
    module Interchanges
      module ThreeHundred
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FortyTen::ElementReqs

          TA1 = s::SegmentDef.build(:TA1, "Interchange Acknowledgement",
            "To report the status of processing a received interchange header and trailer or the non-delivery by a network provider",
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

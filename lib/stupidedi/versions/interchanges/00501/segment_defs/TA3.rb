module Stupidedi
  module Versions
    module Interchanges
      module FiveOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FiftyTen::ElementReqs

          # @todo: Where's the documentation for this?
          TA3 = s::SegmentDef.build(:TA3, "Interchange Delivery Notice", "")

        end
      end
    end
  end
end

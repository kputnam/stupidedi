module Stupidedi
  module Versions
    module Interchanges
      module FiveOhOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = FunctionalGroups::FiftyTen::ElementReqs

          # @todo: Where's the documentation for this?
          ISE = s::SegmentDef.build(:ISE, "Deferred Delivery Request", "")

        end
      end
    end
  end
end

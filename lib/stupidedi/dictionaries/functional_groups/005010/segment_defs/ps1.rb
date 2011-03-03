module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          PS1 = SegmentDef.new :PS1, "Purchase Service",
            "To specify the information about services that are purchased",
            E::E127 .simple_use(Mandatory,  RepeatCount.bounded(1))
            E::E782 .simple_use(Mandatory,  RepeatCount.bounded(1))
            E::E156 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          N2 = SegmentDef.new :N2, "Additional Name Information",
            E::E93  .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E93  .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

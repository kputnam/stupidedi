module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          K3 = SegmentDef.new :K3, "File Information",
            "To transmit a fixed-format record or matrix contents",
            E::E449 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E1333.simple_use(Optional,   RepeatCount.bounded(1)),
            E::C001 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

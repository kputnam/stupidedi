module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDictionary

          N3 = SegmentDef.new \
            :N3, "Party Location",
            "To specify the location of the named party",
            E::E166 .simple_use(Mandatory,  RepeatCount.bounded(1)),
            E::E166 .simple_use(Optional,   RepeatCount.bounded(1))

        end
      end
    end
  end
end

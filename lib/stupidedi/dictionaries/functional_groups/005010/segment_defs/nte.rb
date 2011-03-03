module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          NTE = SegmentDef.build :NTE, "Note/Special Instruction",
            "To transmit information in a free-form format, if necessary, for comment or special instruction",
            E::E363 .simple_use(Optional,   RepeatCount.bounded(1)),
            E::E352 .simple_use(Mandatory,  RepeatCount.bounded(1))

        end
      end
    end
  end
end

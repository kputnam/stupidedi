module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          NTE = s::SegmentDef.build(:NTE, "Note/Special Instruction",
            "To transmit information in a free-form format, if necessary, for comment or special instruction",
            e::E363 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))

        end
      end
    end
  end
end

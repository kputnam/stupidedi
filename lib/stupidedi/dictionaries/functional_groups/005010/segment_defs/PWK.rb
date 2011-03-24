module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          PWK = s::SegmentDef.build(:PWK, "Paperwork",
            "To identify the type or transmission or both of paperwork or support information",
            e::E755 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E756 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E757 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E66  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E67  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E352 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::C002 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1525.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(5, 6))

        end
      end
    end
  end
end

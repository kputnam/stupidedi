module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          QTY = s::SegmentDef.build(:QTY, "Quantity Information",
            "To specify quantity information",
            e::E673.simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E380.simple_use(r::Relational,  s::RepeatCount.bounded(1)),
            e::C001.simple_use(r::Optional,    s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Relational,  s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(2, 4),
            SyntaxNotes::E.build(2, 5))

        end
      end
    end
  end
end

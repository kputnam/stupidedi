module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BSS = s::SegmentDef.build(:BSS, "Beginning Segment for Shipping Schedule/Production Sequence",
            "To transmit identifying numbers, dates, and other basic data relating to the transaction set",
            e::E353.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E127.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E675.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E373.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E328.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E127.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E367.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E324.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E676.simple_use(r::Optional,   s::RepeatCount.bounded(1)))

            # SyntaxNotes::E.build(1, 3),
            # SyntaxNotes::P.build(1, 2),
            # SyntaxNotes::P.build(3, 4),
            # SyntaxNotes::C.build(6, 5),
            # SyntaxNotes::C.build(7, 6))

        end
      end
    end
  end
end

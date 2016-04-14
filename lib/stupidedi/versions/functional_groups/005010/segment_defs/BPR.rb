# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          BPR = s::SegmentDef.build(:BPR, "Financial Information",
            "To indicate the beginning of a Payment Order/Remittance Advice Transaction Set and total payment amount, or to enable related transfer of funds and/or information from payer to payee to occur",
            e::E305 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E478 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E591 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E812 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E506 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E507 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E569 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E508 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E509 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E510 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E506 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E507 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E569 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E508 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1048.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E506 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            e::E507 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E569 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E508 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build( 6,  7),
            SyntaxNotes::C.build( 8,  9),
            SyntaxNotes::P.build(12, 13),
            SyntaxNotes::C.build(14, 15),
            SyntaxNotes::P.build(18, 19),
            SyntaxNotes::C.build(20, 21))

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          L11 = s::SegmentDef.build(:L11, "Business Instructions and Reference Number",
            "To specify instructions in this business relationship or a reference number",
            e::E127 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E128 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E352 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1073.simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::R.build(1,3),
            SyntaxNotes::P.build(1,2))

        end
      end
    end
  end
end

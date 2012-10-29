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
            e::E127.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E128.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1,2))

        end
      end
    end
  end
end

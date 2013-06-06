module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          MS2 = s::SegmentDef.build(:MS2, "Equipment or Container Owner and Type",
            "To specify the owner, the identification number assigned by that owner, and the type of equipment",
            e::E140.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E207.simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1, 2))

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N1  = s::SegmentDef.build(:N1, "Name",
            "To identify a party by type of organization, name, and code",
            e::E98  .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E93  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E66  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E67  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E706 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E98  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(3, 4),
            SyntaxNotes::R.build(2, 3))

        end
      end
    end
  end
end

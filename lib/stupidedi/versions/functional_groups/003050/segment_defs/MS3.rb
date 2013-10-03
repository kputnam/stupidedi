module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          MS3 = s::SegmentDef.build(:MS3, "Interline Information",
            "To identify the interline carrier and relevant data",
            e::E140 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E133 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E19  .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E91  .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E156 .simple_use(r::Relational, s::RepeatCount.bounded(1)),

            SyntaxNotes::C.build(5,3))

        end
      end
    end
  end
end

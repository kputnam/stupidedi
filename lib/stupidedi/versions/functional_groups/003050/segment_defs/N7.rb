module Stupidedi
  module Versions
    module FunctionalGroups
      module ThirtyFifty
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          N7  = s::SegmentDef.build(:N7 , "Equipment Details",
            "To identify the equipment",
            e::E206.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E207.simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E81 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E187.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E167.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E232.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E205.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E183.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E184.simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E102.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E40 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E140.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E319.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E219.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E567.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E571.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E188.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E761.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E56 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E65 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E189.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E24 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E140.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E301.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            SyntaxNotes::P.build(3,  4),
            SyntaxNotes::P.build(5, 16),
            SyntaxNotes::P.build(8,  9))

        end
      end
    end
  end
end

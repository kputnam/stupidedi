# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          CTP = s::SegmentDef.build(:CTP, "Pricing Information",
            "To specify pricing information",
            e::E687 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E236 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E212 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::C001 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E648 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            e::E649 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E782 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E639 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E499 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E289 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build( 4,  5),
            SyntaxNotes::C.build( 6,  7),
            SyntaxNotes::C.build( 9,  2),
            SyntaxNotes::C.build(10,  2),
            SyntaxNotes::C.build(11,  3))

        end
      end
    end
  end
end

module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          HSD = s::SegmentDef.build(:HSD, "Health Care Services Delivery",
            "To specify the delivery pattern of health care services",
            e::E673 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1167.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E615 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E616 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E678 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E679 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(1, 2),
            SyntaxNotes::C.build(6, 5))

        end
      end
    end
  end
end

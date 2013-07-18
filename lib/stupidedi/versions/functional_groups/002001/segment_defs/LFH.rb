module Stupidedi
  module Versions
    module FunctionalGroups
      module TwoThousandOne
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          LFH = s::SegmentDef.build(:LFH, "Hazardous Material Shipping Name",
            "To specify the hazardous material shipping name and additional descriptive requirements",
            e::E808. simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E809. simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E809 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E1023.simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E355 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
            e::E380 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),
            e::E373 .simple_use(r::Optional,   s::RepeatCount.bounded(1)),

            SyntaxNotes::P.build(5, 6))

        end
      end
    end
  end
end

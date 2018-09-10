# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

          TED = s::SegmentDef.build(:TED, "Technical Error Description",
            "To identify the error and, if feasible, the erroneous segment, or data element, or both",
            e::E647 .simple_use(r::Mandatory, s::RepeatCount.bounded(1)),
            e::E3   .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E721 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E719 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E722 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E725 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E724 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),
            e::E961 .simple_use(r::Optional,  s::RepeatCount.bounded(1)),

            SyntaxNotes::C.build(9, 8))

        end
      end
    end
  end
end


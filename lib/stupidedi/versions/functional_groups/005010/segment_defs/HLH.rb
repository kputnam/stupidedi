# frozen_string_literal: true
module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

# Health Related Code (none)
# Height
# Weight

          HLH = s::SegmentDef.build(:HLH, "Health Related Information",
            "",
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E61 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
            e::E81 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end


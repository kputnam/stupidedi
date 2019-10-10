# frozen_string_literal: true
module Stupidedi
  module Versions
    module TwoThousandOne
      module SegmentDefs
        s = Schema
        e = ElementDefs
        r = ElementReqs

        MEA = s::SegmentDef.build(:MEA, "Measurements",
          "To specify physical measurements or counts, including dimensions,
          tolerances, variances, and weights",
          e::E737 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E738 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E739 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E355 .simple_use(r::Mandatory,  s::RepeatCount.bounded(1)),
          e::E740 .simple_use(r::Relational, s::RepeatCount.bounded(1)),
          e::E741 .simple_use(r::Relational, s::RepeatCount.bounded(1)))
      end
    end
  end
end

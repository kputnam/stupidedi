# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          BE834 = d::TransactionSetDef.build("BE", "834",
            "Health Care Claim Payment/Advice")
        end
      end
    end
  end
end

module Stupidedi
  module Contrib
    module ThirtyForty
      module TransactionSetDefs

        SegmentReqs = Versions::FunctionalGroups::ThirtyForty::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::ThirtyForty::SegmentDefs

        autoload :WA142, # Product Service Claim
          "stupidedi/contrib/003040/transaction_set_defs/WA142"

      end
    end
  end
end

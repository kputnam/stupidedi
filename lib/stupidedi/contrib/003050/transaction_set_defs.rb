module Stupidedi
  module Contrib
    module ThirtyFifty
      module TransactionSetDefs

        SegmentReqs = Versions::FunctionalGroups::ThirtyFifty::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::ThirtyFifty::SegmentDefs

        autoload :PO850, # Purchase Order
          "stupidedi/contrib/003050/transaction_set_defs/PO850"
      end
    end
  end
end
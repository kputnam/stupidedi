module Stupidedi
  module Contrib
    module ThirtyTen
      module TransactionSetDefs

        # SegmentReqs = Versions::FunctionalGroups::FortyTen::SegmentReqs
        # SegmentDefs = Versions::FunctionalGroups::FortyTen::SegmentDefs
       
        SegmentReqs = Versions::FunctionalGroups::ThirtyTen::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::ThirtyTen::SegmentDefs

        autoload :RA820, # Remittance Advice
          "stupidedi/contrib/003010/transaction_set_defs/RA820"

        autoload :PO850, # Remittance Advice
          "stupidedi/contrib/003010/transaction_set_defs/PO850"
      end
    end
  end
end

module Stupidedi
  module Contrib
    module TwoThousandOne
      module TransactionSetDefs

        SegmentReqs = Versions::FunctionalGroups::FortyTen::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::FortyTen::SegmentDefs
       
        autoload :SH856, # Ship Notice/Manifest
          "stupidedi/contrib/002001/transaction_set_defs/SH856"

        autoload :RA820, # Ship Notice/Manifest
          "stupidedi/contrib/002001/transaction_set_defs/RA820"

      end
    end
  end
end

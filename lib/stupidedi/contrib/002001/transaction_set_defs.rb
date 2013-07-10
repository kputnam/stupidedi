module Stupidedi
  module Contrib
    module TwoThousandOne
      module TransactionSetDefs

        SegmentReqs = Versions::FunctionalGroups::TwoThousandOne::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::TwoThousandOne::SegmentDefs
       
        autoload :SH856, # Ship Notice/Manifest
          "stupidedi/contrib/004010/transaction_set_defs/SH856"

      end
    end
  end
end

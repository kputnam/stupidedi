module Stupidedi
  module Contrib
    module TwoThousandOne
      module TransactionSetDefs

        # SegmentReqs = Versions::FunctionalGroups::FortyTen::SegmentReqs
        # SegmentDefs = Versions::FunctionalGroups::FortyTen::SegmentDefs
       
        SegmentReqs = Versions::FunctionalGroups::TwoThousandOne::SegmentReqs
        SegmentDefs = Versions::FunctionalGroups::TwoThousandOne::SegmentDefs

        autoload :SH856, # Ship Notice/Manifest
          "stupidedi/contrib/002001/transaction_set_defs/SH856"
      end
    end
  end
end

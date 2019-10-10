# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module TwoThousandOne
      module Standards
        SegmentReqs = Versions::TwoThousandOne::SegmentReqs

        autoload :FA997, "stupidedi/transaction_sets/002001/standards/FA997"
        autoload :PO830, "stupidedi/transaction_sets/002001/standards/PO830"
        autoload :SH856, "stupidedi/transaction_sets/002001/standards/SH856"
      end
    end
  end
end

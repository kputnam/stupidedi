# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyTen
      module Standards
        SegmentReqs = Versions::ThirtyTen::SegmentReqs

        autoload :PC860, "stupidedi/transaction_sets/003010/standards/PC860"
        autoload :PO850, "stupidedi/transaction_sets/003010/standards/PO850"
        autoload :PS830, "stupidedi/transaction_sets/003010/standards/PS830"
        autoload :RA820, "stupidedi/transaction_sets/003010/standards/RA820"
      end
    end
  end
end

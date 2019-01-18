# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        SegmentReqs = Versions::FiftyTen::SegmentReqs

        autoload :BE834, "stupidedi/transaction_sets/005010/standards/BE834"
        autoload :FA999, "stupidedi/transaction_sets/005010/standards/FA999"
        autoload :FA997, "stupidedi/transaction_sets/005010/standards/FA997"
      # autoload :HB271, "stupidedi/transaction_sets/005010/standards/HB271"
        autoload :HC837, "stupidedi/transaction_sets/005010/standards/HC837"
        autoload :HI278, "stupidedi/transaction_sets/005010/standards/HI278"
        autoload :HN277, "stupidedi/transaction_sets/005010/standards/HN277"
        autoload :HP835, "stupidedi/transaction_sets/005010/standards/HP835"
        autoload :HR276, "stupidedi/transaction_sets/005010/standards/HR276"
        autoload :HS270, "stupidedi/transaction_sets/005010/standards/HS270"
        autoload :RA820, "stupidedi/transaction_sets/005010/standards/RA820"
      end
    end
  end
end

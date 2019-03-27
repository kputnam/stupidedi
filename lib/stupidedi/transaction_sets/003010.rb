# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyTen
      SegmentDefs = Versions::ThirtyTen::SegmentDefs

      autoload :Implementations,  "stupidedi/transaction_sets/003010/implementations"
      autoload :Standards,        "stupidedi/transaction_sets/003010/standards"
    end
  end
end

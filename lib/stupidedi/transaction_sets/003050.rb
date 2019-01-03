# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyFifty
      SegmentDefs = Versions::ThirtyFifty::SegmentDefs

      autoload :Implementations,  "stupidedi/transaction_sets/003050/implementations"
      autoload :Standards,        "stupidedi/transaction_sets/003050/standards"
    end
  end
end


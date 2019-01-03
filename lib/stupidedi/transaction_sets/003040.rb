# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyForty
      SegmentDefs = Versions::ThirtyForty::SegmentDefs

      autoload :Implementations,  "stupidedi/transaction_sets/003040/implementations"
      autoload :Standards,        "stupidedi/transaction_sets/003040/standards"
    end
  end
end


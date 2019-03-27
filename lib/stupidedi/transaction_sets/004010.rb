# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      SegmentDefs = Versions::FortyTen::SegmentDefs

      autoload :Implementations,  "stupidedi/transaction_sets/004010/implementations"
      autoload :Standards,        "stupidedi/transaction_sets/004010/standards"
    end
  end
end


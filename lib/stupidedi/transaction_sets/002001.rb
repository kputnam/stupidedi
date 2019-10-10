# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module TwoThousandOne
      SegmentDefs = Versions::TwoThousandOne::SegmentDefs

      autoload :Implementations,  "stupidedi/transaction_sets/002001/implementations"
      autoload :Standards,        "stupidedi/transaction_sets/002001/standards"
    end
  end
end

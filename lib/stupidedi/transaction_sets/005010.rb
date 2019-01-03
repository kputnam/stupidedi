# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      SegmentDefs = Versions::FiftyTen::SegmentDefs

      autoload :Implementations,  "stupidedi/transaction_sets/005010/implementations"
      autoload :Standards,        "stupidedi/transaction_sets/005010/standards"
    end
  end
end

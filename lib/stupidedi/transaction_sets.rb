# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    autoload :Builder,        "stupidedi/transaction_sets/builder"
    autoload :Validation,     "stupidedi/transaction_sets/validation"

    autoload :Common,         "stupidedi/transaction_sets/common"
    autoload :TwoThousandOne, "stupidedi/transaction_sets/002001"
    autoload :ThirtyTen,      "stupidedi/transaction_sets/003010"
    autoload :ThirtyForty,    "stupidedi/transaction_sets/003040"
    autoload :ThirtyFifty,    "stupidedi/transaction_sets/003050"
    autoload :FortyTen,       "stupidedi/transaction_sets/004010"
    autoload :FiftyTen,       "stupidedi/transaction_sets/005010"
  end
end

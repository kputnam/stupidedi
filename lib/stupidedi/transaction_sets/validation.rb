# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module Validation
      autoload :Ambiguity,      "stupidedi/transaction_sets/validation/ambiguity"
      autoload :Implementation, "stupidedi/transaction_sets/validation/implementation"
    end
  end
end

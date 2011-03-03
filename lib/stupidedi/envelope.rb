module Stupidedi

  #
  #
  #
  module Envelope
    autoload :FunctionalGroupDef, "stupidedi/envelope/functional_group_def"
    autoload :FunctionalGroupVal, "stupidedi/envelope/functional_group_val"

    autoload :InterchangeDef,     "stupidedi/envelope/interchange_def"
    autoload :InterchangeVal,     "stupidedi/envelope/interchange_val"

    autoload :TransactionSetDef,  "stupidedi/envelope/transaction_set_def"
    autoload :TransactionSetVal,  "stupidedi/envelope/transaction_set_val"
  end
end

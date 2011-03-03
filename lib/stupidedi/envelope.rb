module Stupidedi
  module Envelope
    autoload :Router,             "stupidedi/envelope/router"

    autoload :FunctionalGroupDef, "stupidedi/schema/functional_group_def"
    autoload :FunctionalGroupVal, "stupidedi/schema/functional_group_val"

    autoload :InterchangeDef,     "stupidedi/schema/interchange_def"
    autoload :InterchangeVal,     "stupidedi/schema/interchange_val"

    autoload :TransactionSetDef,  "stupidedi/schema/transaction_set_def"
    autoload :TransactionSetVal,  "stupidedi/schema/transaction_set_val"
  end
end

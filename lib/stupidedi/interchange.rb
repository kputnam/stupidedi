module Stupidedi
  module Interchange
    autoload :FiveOhOne,                  "stupidedi/interchange/00501"
    autoload :FourOhOne,                  "stupidedi/interchange/00401"
    autoload :TransactionSetHeaderReader, "stupidedi/interchange/transaction_set_header_reader"
  end
end

module Stupidedi
  module Builder
    autoload :AbstractBuilder,        "stupidedi/builder/abstract_builder"
    autoload :TransmissionBuilder,    "stupidedi/builder/transmission_builder"
    autoload :InterchangeBuilder,     "stupidedi/builder/interchange_builder"
    autoload :FunctionalGroupBuilder, "stupidedi/builder/functional_group_builder"
    autoload :TransactionSetBuilder,  "stupidedi/builder/transaction_set_builder"
    autoload :StateMachine,           "stupidedi/builder/state_machine"
  end

  class << Builder
    def new(*args, &block)
      Builder::StateMachine.new(*args, &block)
    end
  end
end

module Stupidedi
  module Builder
    autoload :AbstractState,          "stupidedi/builder/abstract_state"
    autoload :FailureState,           "stupidedi/builder/failure_state"
    autoload :FunctionalGroupBuilder, "stupidedi/builder/functional_group_builder"
    autoload :InterchangeBuilder,     "stupidedi/builder/interchange_builder"
    autoload :LoopBuilder,            "stupidedi/builder/loop_builder"
    autoload :SegmentBuilder,         "stupidedi/builder/segment_builder"
    autoload :StateMachine,           "stupidedi/builder/state_machine"
    autoload :TableBuilder,           "stupidedi/builder/table_builder"
    autoload :TransactionSetBuilder,  "stupidedi/builder/transaction_set_builder"
    autoload :TransmissionBuilder,    "stupidedi/builder/transmission_builder"
  end

  class << Builder
    def new(router)
      Builder::StateMachine.start(router)
    end
  end
end

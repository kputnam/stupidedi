module Stupidedi

  module Builder_
    autoload :AbstractState,        "stupidedi/builder-/abstract_state"
    autoload :FailureState,         "stupidedi/builder-/failure_state"
    autoload :FunctionalGroupState, "stupidedi/builder-/functional_group_state"
    autoload :InterchangeState,     "stupidedi/builder-/interchange_state"
    autoload :LoopState,            "stupidedi/builder-/loop_state"
    autoload :TableState,           "stupidedi/builder-/table_state"
    autoload :TransactionSetState,  "stupidedi/builder-/transaction_set_state"
    autoload :TransmissionState,    "stupidedi/builder-/transmission_state"

    autoload :InstructionTable,     "stupidedi/builder-/instruction_table"
    autoload :Instruction,          "stupidedi/builder-/instruction"
    autoload :StateMachine,         "stupidedi/builder-/state_machine"
  end

end

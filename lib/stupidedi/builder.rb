module Stupidedi
  module Builder
    autoload :ConstraintTable,      "stupidedi/builder/constraint_table"
    autoload :Instruction,          "stupidedi/builder/instruction"
    autoload :InstructionTable,     "stupidedi/builder/instruction_table"

    autoload :BuilderDsl,           "stupidedi/builder/builder_dsl"
    autoload :Generation,           "stupidedi/builder/generation"
    autoload :Navigation,           "stupidedi/builder/navigation"
    autoload :Tokenization,         "stupidedi/builder/tokenization"
    autoload :StateMachine,         "stupidedi/builder/state_machine"

    autoload :AbstractState,        "stupidedi/builder/states/abstract_state"
    autoload :FailureState,         "stupidedi/builder/states/failure_state"
    autoload :FunctionalGroupState, "stupidedi/builder/states/functional_group_state"
    autoload :InitialState,         "stupidedi/builder/states/initial_state"
    autoload :InterchangeState,     "stupidedi/builder/states/interchange_state"
    autoload :LoopState,            "stupidedi/builder/states/loop_state"
    autoload :TableState,           "stupidedi/builder/states/table_state"
    autoload :TransactionSetState,  "stupidedi/builder/states/transaction_set_state"
    autoload :TransmissionState,    "stupidedi/builder/states/transmission_state"
  end
end

# frozen_string_literal: true
module Stupidedi
  module Parser
    autoload :ConstraintTable,      "stupidedi/parser/constraint_table"
    autoload :Instruction,          "stupidedi/parser/instruction"
    autoload :InstructionTable,     "stupidedi/parser/instruction_table"

    autoload :BuilderDsl,           "stupidedi/parser/builder_dsl"
    autoload :Generation,           "stupidedi/parser/generation"
    autoload :Navigation,           "stupidedi/parser/navigation"
    autoload :Tokenization,         "stupidedi/parser/tokenization"
    autoload :StateMachine,         "stupidedi/parser/state_machine"
    autoload :IdentifierStack,      "stupidedi/parser/identifier_stack"

    autoload :AbstractState,        "stupidedi/parser/states/abstract_state"
    autoload :FailureState,         "stupidedi/parser/states/failure_state"
    autoload :FunctionalGroupState, "stupidedi/parser/states/functional_group_state"
    autoload :InitialState,         "stupidedi/parser/states/initial_state"
    autoload :InterchangeState,     "stupidedi/parser/states/interchange_state"
    autoload :LoopState,            "stupidedi/parser/states/loop_state"
    autoload :TableState,           "stupidedi/parser/states/table_state"
    autoload :TransactionSetState,  "stupidedi/parser/states/transaction_set_state"
    autoload :TransmissionState,    "stupidedi/parser/states/transmission_state"
  end

  class << Parser
    # @return [StateMachine]
    def build(*args)
      Parser::StateMachine.build(*args)
    end
  end
end

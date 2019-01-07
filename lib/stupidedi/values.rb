# frozen_string_literal: true
module Stupidedi
  module Values
    autoload :AbstractVal,          "stupidedi/values/abstract_val"
    autoload :TransmissionVal,      "stupidedi/values/transmission_val"
    autoload :InterchangeVal,       "stupidedi/values/interchange_val"
    autoload :FunctionalGroupVal,   "stupidedi/values/functional_group_val"
    autoload :TransactionSetVal,    "stupidedi/values/transaction_set_val"

    autoload :TableVal,             "stupidedi/values/table_val"
    autoload :LoopVal,              "stupidedi/values/loop_val"
    autoload :SegmentVal,           "stupidedi/values/segment_val"
    autoload :InvalidSegmentVal,    "stupidedi/values/invalid_segment_val"
    autoload :InvalidEnvelopeVal,   "stupidedi/values/invalid_envelope_val"
    autoload :SegmentValGroup,      "stupidedi/values/segment_val_group"

    autoload :AbstractElementVal,   "stupidedi/values/abstract_element_val"
    autoload :CompositeElementVal,  "stupidedi/values/composite_element_val"
    autoload :RepeatedElementVal,   "stupidedi/values/repeated_element_val"
    autoload :SimpleElementVal,     "stupidedi/values/simple_element_val"
  end
end

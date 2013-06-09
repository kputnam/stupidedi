module Stupidedi
  module Editor

    autoload :Result,       "stupidedi/editor/result"
    autoload :TA105,        "stupidedi/editor/result"
    autoload :AK905,        "stupidedi/editor/result"
    autoload :IK304,        "stupidedi/editor/result"
    autoload :IK403,        "stupidedi/editor/result"
    autoload :IK502,        "stupidedi/editor/result"
    autoload :ClaimStatus,  "stupidedi/editor/result"
    autoload :Warning,      "stupidedi/editor/result"
    autoload :Error,        "stupidedi/editor/result"
    autoload :ResultSet,    "stupidedi/editor/result_set"

    autoload :AbstractEd,         "stupidedi/editor/abstract_ed"
    autoload :FourOhOneEd,        "stupidedi/editor/00401"
    autoload :FortyTenEd,         "stupidedi/editor/004010"
    autoload :FiveOhOneEd,        "stupidedi/editor/00501"
    autoload :FiftyTenEd,         "stupidedi/editor/005010"
    autoload :TransactionSetEd,   "stupidedi/editor/transaction_set_ed"
    autoload :TransmissionEd,     "stupidedi/editor/transmission_ed"

    autoload :X12,  "stupidedi/editor/X12"
    autoload :X221, "stupidedi/editor/X221-HP835"
    autoload :X222, "stupidedi/editor/X222-HC837"

    # TA1
    autoload :InterchangeAck,
      "stupidedi/editor/interchange_ack"

    # FA 999
    autoload :ImplementationAck,
      "stupidedi/editor/implementation_ack"

    # HN 277CA
    autoload :ClaimAck,
      "stupidedi/editor/claim_ack"

  end
end

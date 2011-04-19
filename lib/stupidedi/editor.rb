module Stupidedi
  module Editor

    autoload :Result,       "stupidedi/editor/result"
    autoload :TA105,        "stupidedi/editor/result"
    autoload :AK905,        "stupidedi/editor/result"
    autoload :IK304,        "stupidedi/editor/result"
    autoload :IK403,        "stupidedi/editor/result"
    autoload :IK502,        "stupidedi/editor/result"
    autoload :ClaimStatus,  "stupidedi/editor/result"
    autoload :ResultSet,    "stupidedi/editor/result_set"

    autoload :AbstractEd,         "stupidedi/editor/abstract_ed"
    autoload :EnvelopeEd,         "stupidedi/editor/envelope_ed"
    autoload :InterchangeEd,      "stupidedi/editor/interchange_ed"
    autoload :FunctionalGroupEd,  "stupidedi/editor/functional_group_ed"
    autoload :TransactionSetEd,   "stupidedi/editor/transaction_set_ed"
    autoload :GuideEd,            "stupidedi/editor/guide_ed"

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

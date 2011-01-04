module Stupidedi
  module FiftyTen
    module Base
      module TransactionSets
        autoload :EligibilityInquiry,           "stupidedi/5010/base/transaction_sets/270_eligibility_inquiry"
        autoload :EligibilityResponse,          "stupidedi/5010/base/transaction_sets/271_eligibility_response"
        autoload :StatusRequest,                "stupidedi/5010/base/transaction_sets/276_status_request"
        autoload :StatusNotification,           "stupidedi/5010/base/transaction_sets/277_status_notification"
        autoload :RemittanceAdvice,             "stupidedi/5010/base/transaction_sets/835_remittance_advice"
        autoload :Claim,                        "stupidedi/5010/base/transaction_sets/837_claim"
        autoload :FunctionalAcknowledgment,     "stupidedi/5010/base/transaction_sets/997_functional_acknowledgment"
        autoload :ImplementationAcknowledgment, "stupidedi/5010/base/transaction_sets/999_implementation_acknowledgment"
      end
    end
  end
end

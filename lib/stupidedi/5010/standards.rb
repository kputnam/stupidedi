module Stupidedi
  module FiftyTen

    #
    # X12 standards, also known as transaction sets, are the foundation for
    # TR3s, aka Implementation Guides.
    #
    # For instance, {Claim} is used to define professional claims {TR3s::X222},
    # institutional claims {TR3s::X223}, and dental claims {TR3s::X224}.
    #
    module Standards
      autoload :EligibilityCoverageOrBenefitInquiry,
        "stupidedi/5010/standards/270_HS_eligibility_coverage_or_benefit_inquiry"

      autoload :EligibilityCoverageOrBenefitInformation,
        "stupidedi/5010/standards/271_HB_eligibility_coverage_or_benefit_information"

      autoload :HealthCareClaimStatusRequest,
        "stupidedi/5010/standards/276_HR_health_care_claimstatus_request"

      autoload :HealthCareInformationStatusNotification,
        "stupidedi/5010/standards/277_HN_health_care_information_status_notification"

      autoload :HealthCareServicesReviewInformation,
        "stupidedi/5010/standards/278_HI_health_care_services_review_information"

      autoload :PaymentOrderRemittanceAdvice,
        "stupidedi/5010/standards/820_RA_payment_order_remittance_advice"

      autoload :BenefitEnrollmentAndMaintenance,
        "stupidedi/5010/standards/834_BE_benefit_enrollment_and_maintenance"

      autoload :HealthCareClaimPaymentAdvice,
        "stupidedi/5010/standards/835_HP_health_care_claim_payment_advice"

      autoload :HealthCareClaim,
        "stupidedi/5010/standards/837_HC_health_care_claim"

      autoload :FunctionalAcknowledgment,
        "stupidedi/5010/standards/997_FA_functional_acknowledgment"

      autoload :ImplementationAcknowledgment,
        "stupidedi/5010/standards/999_FA_implementation_acknowledgment"

      # @private
      S = SegmentDict

      # @private
      L = Designations::LoopRepetition

      # @private
      R = Designations::SegmentRepetition

      # @private
      M = Designations::SegmentRequirement::M

      # @private
      O = Designations::SegmentRequirement::O

    end

  end
end

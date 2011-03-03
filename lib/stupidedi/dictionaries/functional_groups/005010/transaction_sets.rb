module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module TransactionSets

          # 005010X279 Eligibility, Coverage or Benefit Inquiry
          autoload :HS270, # Eligibility, Coverage or Benefit Inquiry
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/270_HS"

          # 005010X279 Eligibility, Coverage or Benefit Response
          autoload :HB271, # Eligibility, Coverage or Benefit Response
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/271_HB"

          # 005010X212 Health Care Claim Status Request
          autoload :HR276, # Health Care Claim Status Request
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/276_HR"

          # 005010X212 Health Care Information Status Notification
          # 005010X214 Health Care Claim Acknowledgment
          autoload :HN277, # Health Care Information Status Notification
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/277_HN"

          # 005010X217 Health Care Services Review Information - Review
          # 005010X217 Health Care Services Review Information - Response
          autoload :HI278, # Health Care Services Review Information
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/278_HI"

          # 005010X218 Payment Order/Remittance Advice
          autoload :RA820, # Payment Order/Remittance Advice
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/820_RA"

          # 005010X220 Benefit Enrollment and Maintenance
          autoload :BE834, # Benefit Enrollment and Maintenance
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/834_BE"

          # 005010X221 Health Care Claim Payment/Advice
          autoload :HP835, # Health Care Claim Payment/Advice
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/835_HP"

          # 005010X222 Health Care Claim: Professional
          # 005010X223 Health Care Claim: Institutional
          # 005010X224 Health Care Claim: Dental
          autoload :HC837, # Health Care Claim
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/837_HC"

          # 005010X230 Functional Acknowledgement
          autoload :FA997, # Functional Acknowledgment
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/997_FA"

          # 005010X231 Functional Acknowledgement
          autoload :FA999, # Implementation Acknowledgment
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/999_FA"

        end
      end
    end
  end
end

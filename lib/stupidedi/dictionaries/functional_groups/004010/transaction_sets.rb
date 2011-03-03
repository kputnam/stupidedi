module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FortyTen
        module TransactionSets

          # 004010X092 Eligibility, Coverage or Benefit Inquiry
          autoload :HS270, # Eligibility, Coverage or Benefit Inquiry
            "stupidedi/dictionaries/functional_groups/005010/transaction_sets/270_HS"

          # 004010X092 Eligibility, Coverage or Benefit Response
          autoload :HB271, # Eligibility, Coverage or Benefit Response
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/271_HB"

          # 004010X151 Patient Information
          autoload :PI275, # Patient Information
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/275_PI"

          # 004010X093 Health Care Claim Status Request
          autoload :HR276, # Health Care Claim Status Request
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/276_HR"

          # 004010X093 Health Care Claim Status Notification
          autoload :HN277, # Health Care Claim Status Notification
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/277_HN"

          # 004010X091 Health Care Claim Payment/Advice
          autoload :HP835, # Health Care Claim Payment/Advice
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/835_HP"

          # 004010X098 Health Care Claim: Professional
          # 004010X096 Health Care Claim: Institutional
          autoload :HC837, # Health Care Claim
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/837_HC"

          # 004010X098 Functional Acknowledgement
          autoload :FA997, # Functional Acknowledgment
            "stupidedi/dictionaries/functional_groups/004010/transaction_sets/997_FA"

        end
      end
    end
  end
end

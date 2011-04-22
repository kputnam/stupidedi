module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          # 005010X187 xx269

          # 005010X279 Eligibility, Coverage or Benefit Inquiry
          autoload :HS270, # Eligibility, Coverage or Benefit Inquiry
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HS270"

          # 005010X279 Eligibility, Coverage or Benefit Response
          autoload :HB271, # Eligibility, Coverage or Benefit Response
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HB271"

          # 005010X209 xx274
          # 005010X254 xx275

          # 005010X212 Health Care Claim Status Request
          autoload :HR276, # Health Care Claim Status Request
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HR276"

          # 005010X212 Health Care Information Status Notification
          # 005010X213
          # 005010X214 Health Care Claim Acknowledgment
          # 005010X228
          autoload :HN277, # Health Care Information Status Notification
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HN277"

          # 005010X215
          # 005010X216
          # 005010X217 Health Care Services Review Information - Review
          # 005010X217 Health Care Services Review Information - Response
          autoload :HI278, # Health Care Services Review Information
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HI278"

          # 005010X218 Payment Order/Remittance Advice
          autoload :RA820, # Payment Order/Remittance Advice
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/RA820"

        # # 005010X220 Benefit Enrollment and Maintenance
        # autoload :BE834, # Benefit Enrollment and Maintenance
        #   "stupidedi/versions/functional_groups/005010/transaction_set_defs/BE834"

          # 005010X221 Health Care Claim Payment/Advice
          autoload :HP835, # Health Care Claim Payment/Advice
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HP835"

          # 005010X222 Health Care Claim: Professional
          # 005010X223 Health Care Claim: Institutional
          # 005010X224 Health Care Claim: Dental
          autoload :HC837, # Health Care Claim
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/HC837"

        # # 005010X230 Functional Acknowledgement
        # autoload :FA997, # Functional Acknowledgment
        #   "stupidedi/versions/functional_groups/005010/transaction_set_defs/FA997"

          # 005010X231 Functional Acknowledgement
          autoload :FA999, # Implementation Acknowledgment
            "stupidedi/versions/functional_groups/005010/transaction_set_defs/FA999"

        end
      end
    end
  end
end

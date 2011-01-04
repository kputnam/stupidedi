module Stupidedi
  module FiftyTen
    module Base
      module TransactionSets

        # This X12 Transaction Set contains the format and establishes the data contents of the Health
        # Care Claim Payment/Advice Transaction Set (835) for use within the context of the Electronic
        # Data Interchange (EDI) environment. This transaction set can be used to make a payment, send
        # an Explanation of Benefits (EOB) remittance advice, or make a payment and send an EOB
        # remittance advice only from a health insurer to a health care provider either directly or via a
        # financial institution.

        def header
          # Table 1
          # =================================
          #
          # 0100 ST   M   Once
          # 0200 BPR  M   Once
          # 0300 NTE  O   Unbounded
          # 0400 TRN  O   Once                ; 1/0400 TRN is used to uniquely identify a claim payment and advice
          # 0500 CUR  O   Once                ; 1/0500 CUR does not initiate a foreign exchange transaction
          # 0600 REF  O   Unbounded
          # 0700 DTM  O   Unbounded
          #
          # Loop 1000     Max(200)
          # --------------------------------+
          # 0800 N1   O   Once              | ; 1/800 N1 loop allows name/address information for the payer and payee
          # 0900 N2   O   Unbounded         | ;   which would be utilzed to address remittance(s) for delivery
          # 1000 N3   O   Unbounded         |
          # 1100 N4   O   Once              |
          # 1200 REF  O   Unbounded         |
          # 1300 PER  O   Unbounded         |
          # 1400 RDM  O   Once              |
          # 1500 DTM  O   Once              |
          # --------------------------------+
        end

        def details
          # Table 2
          # =================================
          #
          # Loop 2000     Unbounded
          # --------------------------------+
          # 0030 LX   O   Once              | ; 2/0030 LX is used to provide a looping structure and logical grouping
          # 0050 TS3  O   Once              | ;          of claim payment information
          # 0070 TS2  O   Once              |
          #                                 |
          # Loop 2100     Unbounded         |
          # ------------------------------+ |
          # 0100 CLP  M   Once            | |
          # 0200 CAS  O   Max(99)         | | ; 2/0200 CAS is used to reflect changes to amounts within Table 2
          # 0300 NM1  M   Max(9)          | |
          # 0330 MIA  O   Once            | |
          # 0350 MOA  O   Once            | |
          # 0400 REF  O   Max(99)         | |
          # 0500 DTM  O   Max(9)          | |
          # 0600 PER  O   Max(3)          | |
          # 0620 AMT  O   Max(20)         | |
          # 0640 QTY  O   Max(20)         | |
          #                               | |
          # Loop 2110     Max(999)        | |
          # ----------------------------+ | |
          # 0700 SVC  O   Once          | | |
          # 0800 DTM  O   Max(9)        | | | ; 2/0800 DTM is used to express dates and ranges specifically related
          # 0900 CAS  O   Max(99)       | | | ;          to the service identified in the SVC segment
          # 1000 REF  O   Max(99)       | | | ; 2/0900 CAS is used to reflect changes to amounts within Table 2
          # 1100 AMT  O   Max(20)       | | |
          # 1200 QTY  O   Max(20)       | | |
          # 1300 LQ   O   Max(99)       | | |
          # ----------------------------+-+-+
        end

        def summary
          # Table 3
          # =================================
          #
          # 0100 PLB  O   Unbounded
          # 0200 SE   M   Once
        end

      end
    end
  end
end

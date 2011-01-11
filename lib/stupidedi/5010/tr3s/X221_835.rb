module Stupidedi
  module FiftyTen
    module TR3s

      module X221
        class TransactionSetHeaderReader < Interchange::TransactionSetHeaderReader
          attr_reader :input, :interchange_header

          def initialize(input, interchange_header)
            @input, @interchange_header = input, interchange_header
          end
        end

        TransactionSetHeaderReader.eigenclass.send(:public, :new)
      end

      class << X221
        def transaction_set_header_reader(input, interchange_header)
          X221::TransactionSetHeaderReader.new(input, interchange_header)
        end
      end

      def header
        # Table 1
        # =================================
        #
        # 0100 ST   R   Once                ; Transaction Set Header
        # 0200 BPR  R   Once                ; Financial Information
        # 0400 TRN  S   Once                ; Reassociation Trace Number
        # 0500 CUR  S   Once                ; Foreign Currency Information
        # 0600 REF  S   Once                ; Receiver Identification (REF01 = EV)
        # 0600 REF  S   Once                ; Version Identification  (REF01 = F2)
        # 0700 DTM  S   Once                ; Production Date
        #
        # Loop 1000A - PAYER IDENTIFICATION     Once
        # --------------------------------+
        # 0800 N1   R   Once              | ; Payer Identification
        # 1000 N3   R   Once              | ; Payer Address
        # 1100 N4   R   Once              | ; Payer City, State, and ZIP Code
        # 1200 REF  S   Max(4)            | ; Additional Payer Identificaiton
        # 1300 PER  S   Once              | ; Payer Business Contact Information  (PER01 = CX)
        # 1300 PER  R   Unbounded         | ; Payer Technical Contact Information (PER01 = BL)
        # 1300 PER  S   Once              | ; Payer Web Site                      (PER01 = IC)
        # --------------------------------+
        #
        # Loop 1000B - PAYER IDENTIFICATION     Once
        # --------------------------------+
        # 0800 N1   R   Once              | ; Payee Identification
        # 1000 N3   S   Once              | ; Payee Address
        # 1100 N4   R   Once              | ; Payee City, State, and ZIP Code
        # 1200 REF  S   Unbounded         | ; Payee Aditional Identificaiton
        # 1400 RDM  S   Once              | ; Remittance Delivery Method
        # --------------------------------+
      end

      def details
        # Table 2
        # =================================
        #
        # Loop 2000 - HEADER NUMBER    Unbounded
        # --------------------------------+
        # 0030 LX   S   Once              | ; Header Number
        # 0050 TS3  S   Once              | ; Provider Summary Information
        # 0070 TS2  S   Once              | ; Provider Supplementary Summary Information
        #                                 |
        # Loop 2100 - CLAIM PAYMENT INFORMATION    Unbounded
        # ------------------------------+ |
        # 0100 CLP  R   Once            | | ; Claim Payment Information
        # 0200 CAS  S   Max(99)         | | ; Claim Adjustment
        # 0300 NM1  R   Once            | | ; Patient Name                    (NM01 = QC)
        # 0300 NM1  S   Once            | | ; Insured Name                    (NM01 = IL)
        # 0300 NM1  S   Once            | | ; Corrected Patient/Insured Name  (NM01 = 74)
        # 0300 NM1  S   Once            | | ; Service Provider Name           (NM01 = 82)
        # 0300 NM1  S   Once            | | ; Crossover Carrier Name          (NM01 = TT)
        # 0300 NM1  S   Once            | | ; Corrected Priority Payer Name   (NM01 = PR)
        # 0300 NM1  S   Once            | | ; Other Subscriber Name           (NM01 = GB)
        # 0330 MIA  S   Once            | | ; Inpatient Adjudication Notification
        # 0350 MOA  S   Once            | | ; Outpatient Adjudication Notification
        # 0400 REF  S   Max(5)          | | ; Other Claim Related Identification  (REF01 = 1L,1W,28,6P,9A,9C,BB,CE,EA,F8,G1,G3,IG,SY)
        # 0400 REF  S   Max(10)         | | ; Rendering Provider Identification   (REF01 = 0B,1A,1B,1C,1D,1G,1H,1J,D3,G2,LU)
        # 0500 DTM  S   Max(2)          | | ; Statement From or To Date (DTM01 = 232,233)
        # 0500 DTM  S   Once            | | ; Coverage Expiration Date  (DTM01 = 036)
        # 0500 DTM  S   Once            | | ; Claim Received Date       (DTM01 = 050)
        # 0600 PER  S   Max(2)          | | ; Claim Contact Information
        # 0620 AMT  S   Max(13)         | | ; Claim Supplemental Information
        # 0640 QTY  S   Max(14)         | | ; Claim Supplemental Quantity
        #                               | |
        # Loop 2110 - SERVICE PAYMENT INFORMATION    Max(999)
        # ----------------------------+ | |
        # 0700 SVC  S   Once          | | | ; Service Payment Information
        # 0800 DTM  S   Max(9)        | | | ; Service Date
        # 0900 CAS  S   Max(99)       | | | ; Service Adjustment
        # 1000 REF  S   Max(8)        | | | ; Service Identification          (REF01 = 1S,APC,BB,E9,G1,G3,LU,RB)
        # 1000 REF  S   Once          | | | ; Line Item Control Number        (REF01 = 6R)
        # 1000 REF  S   Max(10)       | | | ; Rendering Provider Information  (REF01 = 0B,1A,1B,1C,1D,1G,1H,1J,D3,G2,HPI,SY,TJ)
        # 1000 REF  S   Max(5)        | | | ; Health Care Policy Identifier   (REF01 = 0K)
        # 1100 AMT  S   Max(9)        | | | ; Service Supplemental Amount
        # 1200 QTY  S   Max(6)        | | | ; Service Supplemental Quantity
        # 1300 LQ   S   Max(99)       | | | ; Health Care Remark Codes
        # ----------------------------+-+-+
      end

      def summary
        # Table 3
        # =================================
        #
        # 0100 PLB  S   Unbounded           ; Provider Adjustment
        # 0200 SE   R   Once                ; Transaction Set Trailer
      end

    end
  end
end

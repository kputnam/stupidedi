module Stupidedi
  module FiftyTen
    module Standards

      #
      # This X12 Transaction Set contains the format and establishes the data
      # contents of the Health Care Claim Payment/Advice Transaction Set (835)
      # for use within the context of the Electronic Data Interchange (EDI)
      # environment. This transaction set can be used to make a payment, send
      # # an Explanation of Benefits (EOB) remittance advice, or make a
      # payment and send an EOB remittance advice only from a health insurer
      # to a health care provider either directly or via a financial
      # institution.
      #
      module HealthCareClaimPaymentAdvice

        def header
          TableDef.new("Table 1",
            S::ST .segment_use( 100, M, R::Once),
            S::BPR.segment_use( 200, M, R::Once),
            S::NTE.segment_use( 300, O, R::Unbounded),

            # 1/0400 TRN is used to uniquely identify a claim payment and advice
            S::TRN.segment_use( 400, O, R::Once),

            S::CUR.segment_use( 500, O, R::Once),
            S::REF.segment_use( 600, O, R::Unbounded),
            S::DTM.segment_use( 700, O, R::Unbounded),

            LoopDef.new("1000", L::Max(200),
              # 1/800 N1 loop allows name/address information for the payer and
              # payee which would be utilzed to address remittance(s) for
              # delivery
              S::N1 .segment_use( 800, O, R::Once),
              S::N2 .segment_use( 900, O, R::Unbounded),
              S::N3 .segment_use(1000, O, R::Unbounded),
              S::N4 .segment_use(1100, O, R::Once),
              S::REF.segment_use(1200, O, R::Unbounded),
              S::PER.segment_use(1300, O, R::Unbounded),
              S::RDM.segment_use(1400, O, R::Once),
              S::DTM.segment_use(1500, O, R::Once)))
        end

        def details
          TableDef.new("Table 2",
            LoopDef.new("2000", L::Unbounded,
              # 2/0030 LX is used to provide a looping structure and logical
              # grouping of claim payment information
              S::LX .segment_use(  30, O, R::Once),

              S::TS3,segment_use(  50, O, R::Once),
              S::TS2.segment_use(  70, O, R::Once),
              LoopDef.new("2100", L::Unbounded,
                S::CLP.segment_use( 100, M, R::Once),

                # 2/0200 CAS used to reflect changes to amounts within Table 2
                S::CAS.segment_use( 200, O, R::Max(99)),

                S::NM1.segment_use( 300, M, R::Max(9)),
                S::MIA.segment_use( 330, O, R::Once),
                S::MOA.segment_use( 350, O, R::Once),
                S::REF.segment_use( 400, O, R::Max(99)),
                S::DTM.segment_use( 500, O, R::Max(9)),
                S::PER.segment_use( 600, O, R::Max(3)),
                S::AMT.segment_use( 620, O, R::Max(20)),
                S::QTY.segment_use( 640, O, R::Max(20)),
                LoopDef.new("2110", L::Max(999),
                  S::SVC.segment_use( 700, O, R::Once),

                  # 2/0800 DTM is used to express dates and ranges specifically
                  # related to the service identified in the SVC segment
                  S::DTM.segment_use( 800, O, R::Max(9)),

                  # 2/0900 CAS used to reflect changes to amounts within Table 2
                  S::CAS.segment_use( 900, O, R::Max(99)),

                  S::REF.segment_use(1000, O, R::Max(99)),
                  S::AMT.segment_use(1100, O, R::Max(20)),
                  S::QTY.segment_use(1200, O, R::Max(20)),
                  S::LQ .segment_use(1300, O, R::Max(99))))))
        end

        def summary
          TableDef.new "Table 3",
            S::PLB.segment_use( 100, O, R::Unbounded)
            S::SE .segment_use( 200, M, R::Once)
        end
      end

    end
  end
end

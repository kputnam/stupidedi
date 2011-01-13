module Stupidedi
  module FiftyTen
    module Standards

      #
      # This X12 Transaction Set contains the format and establishes the data
      # contents of the Health Care Claim Transaction Set (837) for use within
      # the context of an Electronic Data Interchange (EDI) environment. This
      # transaction set can be used to submit health care claim billing
      # information, encounter information, or both, from providers of health
      # care services to payers, either directly or via intermediary billers and
      # claims clearinghouses. It can also be used to transmit health care
      # claims and billing payment information between payers with different
      # payment responsibilities where coordination of benefits is required or
      # between payers and regulatory agencies to monitor the rendering,
      # billing, and/or payment of health care services within a specific health
      # care/insurance industry segment.
      #
      # For purposes of this standard, providers of health care products or
      # services may include entities such as physicians, hospitals and other
      # medical facilities or suppliers, dentists, and pharmacies, and entities
      # providing medical information to meet regulatory requirements. The payer
      # refers to a third party entity that pays claims or administers the
      # insurance product or benefit or both. For example, a payer may be an
      # insurance company, health maintenance organization (HMO), preferred
      # provider organization (PPO), government agency (Medicare, Medicaid,
      # Civilian Health and Medical Program of the Uniformed Services (CHAMPUS),
      # etc.) or an entity such as a third party administrator (TPA) or third
      # party organization (TPO) that may be contracted by one of those groups.
      # A regulatory agency is an entity responsible, by law or rule, for
      # administering and monitoring a statutory benefits program or a specific
      # health care/insurance industry segment
      #
      module HealthCareClaim

        def header
          TableDef.new("Table 1",
            S::ST .segment_use(  50, M, R::Once),
            S::BHT.segment_use( 100, M, R::Once),
            S::REF.segment_use( 150, O, R::Max(3)),
            LoopDef.new("1000", L::Max(10),
              # Loop 1000 contains submittend and receiver information. If any
              # intermediary receivers change or add data in any way, then they
              # add an occurrence to the loop as a form of identification. The
              # added loop occurence must be the last occurrence of the loop.
              S::NM1.segment_use( 200, O, R::Once),
              S::N2 .segment_use( 250, O, R::Max(2)),
              S::N3 .segment_use( 300, O, R::Max(2)),
              S::N4 .segment_use( 350, O, R::Once),
              S::REF.segment_use( 400, O, R::Max(2)),
              S::PER.segment_use( 450, O, R::Max(2))))
        end

        def detail
          TableDef.new("Table 2",
            LoopDef.new("2000", L::Unbounded,
              S::HL .segment_use(  10, M, R::Once),
              S::PRV.segment_use(  30, O, R::Once),
              S::SBR.segment_use(  50, O, R::Once),
              S::PAT.segment_use(  70, O, R::Once),
              S::DTP.segment_use(  90, O, R::Max(5)),
              S::CUR.segment_use( 100, O, R::Once),
              LoopDef.new("2010", L::Max(10),
                # Loop 2010 contains information about entities that apply to
                # all claims in loop 2300. For example, these entities may
                # include billing provider, pay-to provider, insurer, primary
                # administrator, contract holder, or claimant.
                S::NM1.segment_use( 150, O, R::Once),
                S::N2 .segment_use( 200, O, R::Max(2)),
                S::N3 .segment_use( 250, O, R::Max(2)),
                S::N4 .segment_use( 300, O, R::Once),
                S::DMG.segment_use( 320, O, R::Once),
                S::REF.segment_use( 350, O, R::Max(20)),
                S::PER.segment_use( 400, O, R::Max(2))),
              LoopDef.new("2300", L::Max(100),
                S::CLM.segment_use(1300, O, R::Once),
                S::DTP.segment_use(1350, O, R::Max(150)),
                S::CL1.segment_use(1400, O, R::Once),
                S::DN1.segment_use(1450, O, R::Once),
                S::DN2.segment_use(1500, O, R::Max(35)),
                S::PWK.segment_use(1550, O, R::Max(10)),
                S::CN1.segment_use(1600, O, R::Once),
                # Can't find a definition for these segments because
                # they aren't used in 837D, 837I, or 837P
                # S::DSB.segment_use(1650, O, R::Once),
                # S::UR .segment_use(1700, O, R::Once),
                S::AMT.segment_use(1750, O, R::Max(40)),
                S::REF.segment_use(1800, O, R::Max(30)),
                S::K3 .segment_use(1850, O, R::Max(10)),
                S::NTE.segment_use(1900, O, R::Max(20)),
                # The CR1 through CR5 and CRC cerification segments appear both
                # on the claim level and the service line level because
                # cerifications can be submitted for all services on a claim or
                # for individual services. Certification information at the
                # claim level applies to all service lines of the claim, unless
                # overridden by certification information at the service line
                # level.
                S::CR1.segment_use(1950, O, R::Once),
                S::CR2.segment_use(2000, O, R::Once),
                S::CR3.segment_use(2050, O, R::Once),
                # Can't find a definition for these segments because
                # they are not used in 837D, 837I, or 837P
                # S::CR4.segment_use(2100, O, R::Max(3)),
                # S::CR5.segment_use(2150, O, R::Once),
                # S::CR6.segment_use(2160, O, R::Once),
                # S::CR8.segment_use(2190, O, R::Max(9)),
                S::CRC.segment_use(2200, O, R::Max(100)),
                S::HI .segment_use(2310, O, R::Max(25)),
                S::QTY.segment_use(2400, O, R::Max(10)),
                S::HCP.segment_use(2410, O, R::Once),

                # Can't find definitions for these segments because
                # they are not used in 837D, 837I, or 837P
                # LoopDef.new("2305", L::Max(6),
                  # S::CR7.segment_use(2420, O, R::Once),
                  # S::HSD.segment_use(2430, O, R::Max(12))),

                LoopDef.new("2310", L::Max(9),
                  # Loop 2310 contains information about the rendering,
                  # referring, or attending provider.
                  S::NM1.segment_use(2500, O, R::Once),
                  S::PRV.segment_use(2550, O, R::Once),
                  S::N2 .segment_use(2600, O, R::Max(2)),
                  S::N3 .segment_use(2650, O, R::Max(2)),
                  S::N4 .segment_use(2700, O, R::Once),
                  S::REF.segment_use(2710, O, R::Max(20)),
                  S::PER.segment_use(2750, O, R::Max(2))),
                LoopDef.new("2320", L::Max(10),
                  # Loop 2320 contains insurance information about paying and
                  # other insurance carries for that subscriber, subscriber of
                  # the other insurance carriers, school or employer information
                  # for that subscriber.
                  S::SBR.segment_use(2900, O, R::Once),
                  S::CAS.segment_use(2950, O, R::Max(99)),
                  S::AMT.segment_use(3000, O, R::Max(15)),
                  S::DMG.segment_use(3050, O, R::Once),
                  S::OI .segment_use(3100, O, R::Once),
                  S::MIA.segment_use(3150, O, R::Once),
                  S::MOA.segment_use(3200, O, R::Once),
                  LoopDef.new("2330", L::Max(10),
                    # Segments NM1-N4 contain name and address information of
                    # the insurance carriers referenced in the loop 2320.
                    S::NM1.segment_use(3250, O, R::Once),
                    S::N2 .segment_use(3300, O, R::Max(2)),
                    S::N3 .segment_use(3320, O, R::Max(2)),
                    S::N4 .segment_use(3400, O, R::Once),
                    S::PER.segment_use(3450, O, R::Max(2)),
                    S::DTP.segment_use(3500, O, R::Max(9)),
                    S::REF.segment_use(3550, O, R::Unbounded))),
                LoopDef.new("2400", L::Unbounded,
                  # Loop 2400 contains service line information
                  S::LX .segment_use(3650, O, R::Once),
                  S::SV1.segment_use(3700, O, R::Once),
                  S::SV2.segment_use(3750, O, R::Once),
                  S::SV3.segment_use(3800, O, R::Once),
                  S::TOO.segment_use(3820, O, R::Max(32)),
                  # Can't find a definition for this segment because
                  # they aren't not used in 837D, 837I, or 837P
                  # S::SV4.segment_use(3850, O, R::Once),
                  S::SV5.segment_use(4000, O, R::Once),
                  # S::SV6.segment_use(4050, O, R::Once),
                  # S::SV7.segment_use(4100, O, R::Once),
                  S::HI .segment_use(4150, O, R::Max(25)),
                  S::PWK.segment_use(4200, O, R::Max(10)),
                  # The CR1 through CR5 and CRC certification segments appear
                  # both on the claim level and the service line level because
                  # certifications can be submitted for all services on a claim
                  # or for individual services. Certification information at the
                  # claim level applies to all service lines of the claim,
                  # unless overridden by certification information at the
                  # service line level.
                  S::CR1.segment_use(4250, O, R::Once),
                  S::CR2.segment_use(4300, O, R::Max(5)),
                  S::CR3.segment_use(4350, O, R::Once),
                  # S::CR4.segment_use(4400, O, R::Max(3)),
                  # S::CR5.segment_use(4450, O, R::Once),
                  S::CRC.segment_use(4500, O, R::Max(3)),
                  S::DTP.segment_use(4550, O, R::Max(15)),
                  S::QTY.segment_use(4600, O, R::Max(5)),
                  S::MEA.segment_use(4620, O, R::Max(20)),
                  S::CN1.segment_use(4650, O, R::Once),
                  S::REF.segment_use(4700, O, R::Max(30)),
                  S::AMT.segment_use(4750, O, R::Max(15)),
                  S::K3 .segment_use(4800, O, R::Max(10)),
                  S::NTE.segment_use(4850, O, R::Max(10)),
                  S::PS1.segment_use(4880, O, R::Once),
                  # S::IMM.segment_use(4900, O, R::Unbounded),
                  # S::HSD.segment_use(4910, O, R::Once),
                  S::HCP.segment_use(4920, O, R::Once),
                  LoopDef.new("2410", L::Unbounded,
                    # Loop 2410 contains compound drug components, quantities,
                    # and prices.
                    S::LIN.segment_use(4930, O, R::Once),
                    S::CTP.segment_use(4940, O, R::Once),
                    S::REF.segment_use(4950, O, R::Once)),
                  LoopDef.new("2420", L::Max(20),
                    # Loop 2420 contains information about the rendering,
                    # referring, or attending provider on a service level. These
                    # segments override the information in the claim-level
                    # segments if the entity identifier codes in each NM1
                    # segment are the same.
                    S::NM1.segment_use(5000, O, R::Once),
                    S::PRV.segment_use(5050, O, R::Once),
                    S::N2 .segment_use(5100, O, R::Max(2)),
                    S::N3 .segment_use(5140, O, R::Max(2)),
                    S::N4 .segment_use(5200, O, R::Once),
                    S::REF.segment_use(5250, O, R::Max(20)),
                    S::PER.segment_use(5300, O, R::Max(2))),
                  LoopDef.new("2430", L::Unbounded,
                    # SVD01 identifies the payer which adjudicated the
                    # corresponding service line and must match DE67 in the
                    # NM109 position 3250 for the payer.
                    S::SVD.segment_use(5400, O, R::Once),
                    S::CAS.segment_use(5450, O, R::Max(99)),
                    S::DTP.segment_use(5500, O, R::Max(9)),
                    S::AMT.segment_use(5505, O, R::Max(20))),
                  LoopDef.new("2440", L::Unbounded,
                    # Loop 2440 provides certificate of medical necessity
                    # information for the procedure identified in SV101 in
                    # position 3700.
                    S::LQ .segment_use(5510, O, R::Once),
                    # FRM segment provides question numbers and responses for
                    # questions on the medical necessity information form
                    # identified in LQ position 5510.
                    S::FRM.segment_use(5520, M, R::Max(99)))))))
        end

        def summary
          TableDef.new("Table 3",
            S::SE .segment_use(5550, M, R::Once))
        end
      end

    end
  end
end

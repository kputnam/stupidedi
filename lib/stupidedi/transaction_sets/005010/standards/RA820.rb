# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        RA820 = b.build("RA", "820", "Payment Order/Remittance Advice",
          d::TableDef.header("1 - Header",
            s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            #::BHT.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BPR.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
            s::NTE.use(300, r::Optional,  d::RepeatCount.unbounded),
            s::TRN.use(350, r::Optional,  d::RepeatCount.bounded(1)),
            s::CUR.use(400, r::Optional,  d::RepeatCount.bounded(1)),
            s::REF.use(500, r::Optional,  d::RepeatCount.unbounded),
            s::DTM.use(600, r::Optional,  d::RepeatCount.unbounded),

            d::LoopDef.build("N1", d::RepeatCount.unbounded,
              s:: N1.use( 700, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N2.use( 800, r::Optional,  d::RepeatCount.unbounded),
              s:: N3.use( 900, r::Optional,  d::RepeatCount.unbounded),
              s:: N4.use(1000, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(1100, r::Optional,  d::RepeatCount.unbounded),
              s::PER.use(1200, r::Optional,  d::RepeatCount.unbounded),
              s::RDM.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
              s::DTM.use(1400, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("ENT", d::RepeatCount.unbounded,
              s::ENT.use( 100, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("ENT/FA1", d::RepeatCount.unbounded,
                s::FA1.use( 150, r::Optional,  d::RepeatCount.bounded(1)),
                s::FA2.use( 160, r::Mandatory, d::RepeatCount.unbounded)),

              d::LoopDef.build("ENT/NM1", d::RepeatCount.unbounded,
                s::NM1.use( 200, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N2.use( 300, r::Optional,  d::RepeatCount.unbounded),
                s:: N3.use( 400, r::Optional,  d::RepeatCount.unbounded),
                s:: N4.use( 500, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use( 600, r::Optional,  d::RepeatCount.unbounded),
                s::PER.use( 700, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("ENT/ADX", d::RepeatCount.unbounded,
                s::ADX.use( 800, r::Optional,  d::RepeatCount.bounded(1)),
                s::NTE.use( 900, r::Optional,  d::RepeatCount.unbounded),
                s::PER.use(1000, r::Optional,  d::RepeatCount.unbounded),
                s::DTM.use(1050, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("ENT/ADX/REF", d::RepeatCount.unbounded,
                  s::REF.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTM.use(1200, r::Optional,  d::RepeatCount.unbounded)),

                d::LoopDef.build("ENT/ADX/IT1", d::RepeatCount.unbounded,
                  s::IT1.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::RPA.use(1310, r::Optional,  d::RepeatCount.bounded(1)),
                  s::QTY.use(1320, r::Optional,  d::RepeatCount.bounded(1)),

                  d::LoopDef.build("ENT/ADX/IT1/REF", d::RepeatCount.unbounded,
                    s::REF.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTM.use(1410, r::Optional,  d::RepeatCount.bounded(1))),

                  d::LoopDef.build("ENT/ADX/IT1/SAC", d::RepeatCount.unbounded,
                    s::SAC.use(1420, r::Optional,  d::RepeatCount.bounded(1)),
                    s::TXI.use(1430, r::Optional,  d::RepeatCount.unbounded),
                    s::DTM.use(1440, r::Optional,  d::RepeatCount.bounded(10))),

                  d::LoopDef.build("ENT/ADX/IT1/SLN", d::RepeatCount.unbounded,
                    s::SLN.use(1450, r::Optional,  d::RepeatCount.bounded(1)),

                    d::LoopDef.build("ENT/ADX/IT1/SLN/REF", d::RepeatCount.unbounded,
                      s::REF.use(1460, r::Optional,  d::RepeatCount.bounded(1)),
                      s::DTM.use(1470, r::Optional,  d::RepeatCount.unbounded)),

                    d::LoopDef.build("ENT/ADX/IT1/SLN/SAC", d::RepeatCount.unbounded,
                      s::SAC.use(1480, r::Optional,  d::RepeatCount.bounded(1)),
                      s::TXI.use(1490, r::Optional,  d::RepeatCount.unbounded)))),

                d::LoopDef.build("ENT/ADX/FA1", d::RepeatCount.unbounded,
                  s::FA1.use(1495, r::Optional,  d::RepeatCount.bounded(1)),
                  s::FA2.use(1496, r::Mandatory, d::RepeatCount.bounded(1)))),

              d::LoopDef.build("ENT/RMR", d::RepeatCount.unbounded,
                s::RMR.use(1500, r::Optional,  d::RepeatCount.bounded(1)),
                s::NTE.use(1600, r::Optional,  d::RepeatCount.unbounded),
                s::REF.use(1700, r::Optional,  d::RepeatCount.unbounded),
                s::DTM.use(1800, r::Optional,  d::RepeatCount.unbounded),
                s::VEH.use(1850, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("ENT/RMR/IT1", d::RepeatCount.unbounded,
                  s::IT1.use(1900, r::Optional,  d::RepeatCount.bounded(1)),
                  s::RPA.use(1920, r::Optional,  d::RepeatCount.bounded(1)),
                  s::QTY.use(1940, r::Optional,  d::RepeatCount.bounded(1)),

                  d::LoopDef.build("ENT/RMR/IT1/REF", d::RepeatCount.unbounded,
                    s::REF.use(2000, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTM.use(2010, r::Optional,  d::RepeatCount.bounded(1))),

                  d::LoopDef.build("ENT/RMR/IT1/SAC", d::RepeatCount.unbounded,
                    s::SAC.use(2020, r::Optional,  d::RepeatCount.bounded(1)),
                    s::TXI.use(2030, r::Optional,  d::RepeatCount.unbounded)),

                  d::LoopDef.build("ENT/RMR/IT1/SLN", d::RepeatCount.unbounded,
                    s::SLN.use(2040, r::Optional,  d::RepeatCount.bounded(1)),

                    d::LoopDef.build("ENT/RMR/IT1/SLN/REF", d::RepeatCount.unbounded,
                      s::REF.use(2050, r::Optional,  d::RepeatCount.bounded(1)),
                      s::DTM.use(2060, r::Optional,  d::RepeatCount.unbounded)),

                    d::LoopDef.build("ENT/RMR/IT1/SLN/SAC", d::RepeatCount.unbounded,
                      s::SAC.use(2070, r::Optional,  d::RepeatCount.bounded(1)),
                      s::TXI.use(2080, r::Optional,  d::RepeatCount.unbounded)))),

                d::LoopDef.build("ENT/RMR/ADX", d::RepeatCount.unbounded,
                  s::ADX.use(2100, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NTE.use(2200, r::Optional,  d::RepeatCount.unbounded),
                  s::PER.use(2300, r::Optional,  d::RepeatCount.unbounded),

                  d::LoopDef.build("ENT/RMR/ADX/REF", d::RepeatCount.unbounded,
                    s::REF.use(2400, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTM.use(2500, r::Optional,  d::RepeatCount.unbounded)),

                  d::LoopDef.build("ENT/RMR/ADX/IT1", d::RepeatCount.unbounded,
                    s::IT1.use(2600, r::Optional,  d::RepeatCount.bounded(1)),
                    s::RPA.use(2610, r::Optional,  d::RepeatCount.bounded(1)),
                    s::QTY.use(2620, r::Optional,  d::RepeatCount.bounded(1)),

                    d::LoopDef.build("ENT/RMR/ADX/IT1/REF", d::RepeatCount.unbounded,
                      s::REF.use(2700, r::Optional,  d::RepeatCount.bounded(1)),
                      s::DTM.use(2710, r::Optional,  d::RepeatCount.bounded(1))),

                    d::LoopDef.build("ENT/RMR/ADX/IT1/SAC", d::RepeatCount.unbounded,
                      s::SAC.use(2720, r::Optional,  d::RepeatCount.bounded(1)),
                      s::TXI.use(2730, r::Optional,  d::RepeatCount.unbounded),
                      s::DTM.use(2740, r::Optional,  d::RepeatCount.bounded(10)))),

                    d::LoopDef.build("ENT/RMR/ADX/IT1/SLN", d::RepeatCount.unbounded,
                      s::SLN.use(2750, r::Optional,  d::RepeatCount.bounded(1)),

                      d::LoopDef.build("ENT/RMR/ADX/IT1/SLN/REF", d::RepeatCount.unbounded,
                        s::REF.use(2760, r::Optional,  d::RepeatCount.bounded(1)),
                        s::DTM.use(2770, r::Optional,  d::RepeatCount.unbounded)),

                      d::LoopDef.build("ENT/RMR/ADX/IT1/SLN/SAC", d::RepeatCount.unbounded,
                        s::SAC.use(2780, r::Optional,  d::RepeatCount.bounded(1)),
                        s::TXI.use(2790, r::Optional,  d::RepeatCount.unbounded)))),

                d::LoopDef.build("ENT/RMR/FA1", d::RepeatCount.unbounded,
                  s::FA1.use(2795, r::Optional,  d::RepeatCount.bounded(1)),
                  s::FA2.use(2796, r::Optional,  d::RepeatCount.unbounded))),

            d::LoopDef.build("TXP", d::RepeatCount.unbounded,
              s::TXP.use(2800, r::Optional,  d::RepeatCount.bounded(1)),
              s::TXI.use(2850, r::Optional,  d::RepeatCount.unbounded),
              s::REF.use(2855, r::Optional,  d::RepeatCount.unbounded),
              s::DTM.use(2860, r::Optional,  d::RepeatCount.unbounded)),

            d::LoopDef.build("DED", d::RepeatCount.unbounded,
              s::DED.use(2870, r::Optional,  d::RepeatCount.bounded(1))),

            d::LoopDef.build("LX", d::RepeatCount.unbounded,
              s:: LX.use(2900, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(2950, r::Optional,  d::RepeatCount.unbounded),
              s::TRN.use(3000, r::Optional,  d::RepeatCount.unbounded),

              d::LoopDef.build("LX/NM1", d::RepeatCount.unbounded,
                s::NM1.use(3050, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(3100, r::Optional,  d::RepeatCount.unbounded),
                s::G53.use(3150, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("LX/NM1/AIN", d::RepeatCount.unbounded,
                  s::AIN.use(3200, r::Optional,  d::RepeatCount.bounded(1)),
                  s::QTY.use(3250, r::Optional,  d::RepeatCount.unbounded),
                  s::DTP.use( 330, r::Optional,  d::RepeatCount.unbounded)),

                d::LoopDef.build("LX/NM1/PEN", d::RepeatCount.unbounded,
                  s::PEN.use(3350, r::Optional,  d::RepeatCount.bounded(1)),
                  s::AMT.use(3400, r::Optional,  d::RepeatCount.unbounded),
                  s::DTP.use(3450, r::Optional,  d::RepeatCount.unbounded),

                  d::LoopDef.build("LX/NM1/PEN/INV", d::RepeatCount.unbounded,
                    s::INV.use(3500, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTP.use(3550, r::Optional,  d::RepeatCount.unbounded))))),

            d::LoopDef.build("N9", d::RepeatCount.unbounded,
              s:: N9.use(3600, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(3650, r::Optional,  d::RepeatCount.unbounded),

              d::LoopDef.build("N9/AMT", d::RepeatCount.unbounded,
                s::AMT.use(3700, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(3800, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("N9/N1", d::RepeatCount.unbounded,
                s:: N1.use(3900, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(4000, r::Optional,  d::RepeatCount.unbounded),

                d::LoopDef.build("N9/N1/EMS", d::RepeatCount.unbounded,
                  s::EMS.use(4100, r::Optional,  d::RepeatCount.bounded(1)),
                  s::ATN.use(4200, r::Optional,  d::RepeatCount.unbounded),
                  s::AIN.use(4300, r::Optional,  d::RepeatCount.unbounded),
                  s::PYD.use(4400, r::Optional,  d::RepeatCount.unbounded)))),

            d::LoopDef.build("RYL", d::RepeatCount.unbounded,
              s::RYL.use(4500, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("RYL/NM1", d::RepeatCount.unbounded,
                s::NM1.use(4600, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("RYL/NM1/LOC", d::RepeatCount.unbounded,
                  s::LOC.use(4700, r::Optional,  d::RepeatCount.bounded(1)),

                  d::LoopDef.build("RYL/NM1/LOC/PID", d::RepeatCount.unbounded,
                    s::PID.use(4800, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTM.use(4900, r::Optional,  d::RepeatCount.bounded(1)),

                    d::LoopDef.build("RYL/NM1/LOC/PID/PCT", d::RepeatCount.unbounded,
                      s::PCT.use(5000, r::Optional,  d::RepeatCount.bounded(1)),
                      s::QTY.use(5100, r::Optional,  d::RepeatCount.bounded(1)),

                      d::LoopDef.build("RYL/NM1/LOC/PID/PCT/AMT", d::RepeatCount.unbounded,
                        s::AMT.use(5200, r::Optional,  d::RepeatCount.bounded(1)),
                        s::ADX.use(5300, r::Optional,  d::RepeatCount.unbounded))))),

                d::LoopDef.build("RYL/NM1/ASM", d::RepeatCount.unbounded,
                  s::ASM.use(5400, r::Optional,  d::RepeatCount.bounded(1)),
                  s::ADX.use(5500, r::Optional,  d::RepeatCount.bounded(1))))))),

          d::TableDef.summary("3 - Summary",
            s:: SE.use( 100, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

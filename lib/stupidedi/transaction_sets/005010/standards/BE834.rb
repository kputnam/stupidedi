# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        BE834 = b.build("BE", "834", "Benefit Enrollment and Maintenance",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BGN.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
            s::REF.use(300, r::Optional,  d::RepeatCount.bounded(1)),
            s::DTP.use(400, r::Optional,  d::RepeatCount.unbounded),
            s::QTY.use(600, r::Optional,  d::RepeatCount.bounded(3)),

            d::LoopDef.build("1000", d::RepeatCount.unbounded,
              s:: N1.use( 700, r::Mandatory, d::RepeatCount.bounded(1)),
              s:: N2.use( 800, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N3.use( 900, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use(1000, r::Optional,  d::RepeatCount.bounded(1)),
              s::PER.use(1100, r::Optional,  d::RepeatCount.bounded(3)),

              d::LoopDef.build("1100", d::RepeatCount.bounded(1),
                s::ACT.use(1200, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(1300, r::Optional,  d::RepeatCount.bounded(5)),
                s:: N3.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(1500, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(1600, r::Optional,  d::RepeatCount.bounded(5)),
                s::DTP.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s::AMT.use(1800, r::Optional,  d::RepeatCount.bounded(1))))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("2000", d::RepeatCount.unbounded,
              s::INS.use(100, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(200, r::Mandatory, d::RepeatCount.unbounded),
              s::DTP.use(250, r::Optional,  d::RepeatCount.unbounded),

              d::LoopDef.build("2100", d::RepeatCount.bounded(1),
                s::NM1.use( 300, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use( 400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use( 500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use( 600, r::Optional,  d::RepeatCount.bounded(1)),
                s::DMG.use( 800, r::Optional,  d::RepeatCount.bounded(1)),
                s:: PM.use(1000, r::Optional,  d::RepeatCount.bounded(1)),
                s:: EC.use(1000, r::Optional,  d::RepeatCount.unbounded),
                s::ICM.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
                s::AMT.use(1200, r::Optional,  d::RepeatCount.bounded(10)),
                s::HLH.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                s:: HI.use(1400, r::Optional,  d::RepeatCount.bounded(10)),
                s::LUI.use(1500, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("2200", d::RepeatCount.bounded(4),
                s::DSB.use(2000, r::Optional, d::RepeatCount.bounded(1)),
                s::DTP.use(2100, r::Optional, d::RepeatCount.bounded(10)),
                s::AD1.use(2200, r::Optional, d::RepeatCount.bounded(10))),

              d::LoopDef.build("2300", d::RepeatCount.bounded(99),
                s:: HD.use(2600, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTP.use(2700, r::Optional,  d::RepeatCount.bounded(10)),
                s::AMT.use(2800, r::Optional,  d::RepeatCount.bounded(3)),
                s::REF.use(2900, r::Optional,  d::RepeatCount.bounded(5)),
                s::IDC.use(3000, r::Optional,  d::RepeatCount.unbounded),

                d::LoopDef.build("2310", d::RepeatCount.bounded(30),
                  s:: LX.use(3100, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(3200, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N1.use(3300, r::Optional,  d::RepeatCount.bounded(3)),
                  s:: N2.use(3400, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N3.use(3500, r::Optional,  d::RepeatCount.bounded(2)),
                  s:: N4.use(3600, r::Optional,  d::RepeatCount.bounded(2)),
                  s::PER.use(3700, r::Optional,  d::RepeatCount.bounded(2)),
                  s::PRV.use(3800, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTP.use(3900, r::Optional,  d::RepeatCount.bounded(6)),
                  s::PLA.use(3950, r::Optional,  d::RepeatCount.bounded(1))),

                d::LoopDef.build("2320", d::RepeatCount.bounded(5),
                  s::COB.use(4000, r::Optional, d::RepeatCount.bounded(1)),
                  s::REF.use(4050, r::Optional, d::RepeatCount.unbounded),
                  s::DTP.use(4070, r::Optional, d::RepeatCount.bounded(2)),

                  d::LoopDef.build("2330", d::RepeatCount.bounded(3),
                    s::NM1.use(4100, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N2.use(4200, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N3.use(4300, r::Optional,  d::RepeatCount.bounded(2)),
                    s:: N4.use(4400, r::Optional,  d::RepeatCount.bounded(1)),
                    s::PER.use(4500, r::Optional,  d::RepeatCount.bounded(1))))),

              d::LoopDef.build("2400", d::RepeatCount.bounded(10),
                s:: LC.use(4600, r::Optional,  d::RepeatCount.bounded(1)),
                s::AMT.use(4700, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTP.use(4800, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(4850, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("2410", d::RepeatCount.bounded(20),
                  s::BEN.use(4900, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(5000, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N1.use(5100, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N2.use(5200, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N3.use(5300, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N4.use(5400, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DMG.use(5420, r::Optional,  d::RepeatCount.bounded(1)))),

              d::LoopDef.build("2500", d::RepeatCount.bounded(5),
                  s::FSA.use(5500, r::Optional,  d::RepeatCount.bounded(1)),
                  s::AMT.use(5600, r::Optional,  d::RepeatCount.bounded(10)),
                  s::DTP.use(5700, r::Optional,  d::RepeatCount.bounded(10)),
                  s::REF.use(5750, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("2600", d::RepeatCount.unbounded,
                  s:: RP.use(5800, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTP.use(5900, r::Optional,  d::RepeatCount.unbounded),
                  s::REF.use(5920, r::Optional,  d::RepeatCount.unbounded),
                  s::INV.use(5940, r::Optional,  d::RepeatCount.unbounded),
                  s::AMT.use(5960, r::Optional,  d::RepeatCount.bounded(20)),
                  s::QTY.use(5970, r::Optional,  d::RepeatCount.bounded(20)),
                  s:: K3.use(5980, r::Optional,  d::RepeatCount.bounded(3)),
                  s::REL.use(6000, r::Optional,  d::RepeatCount.bounded(1)),

                  d::LoopDef.build("2610", d::RepeatCount.unbounded,
                    s::NM1.use(6100, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N2.use(6300, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DMG.use(6510, r::Optional,  d::RepeatCount.bounded(1)),
                    s::BEN.use(6520, r::Optional,  d::RepeatCount.bounded(1)),
                    s::REF.use(6530, r::Optional,  d::RepeatCount.unbounded),

                    d::LoopDef.build("2620", d::RepeatCount.unbounded,
                      s::NX1.use(6540, r::Optional, d::RepeatCount.bounded(1)),
                      s:: N3.use(6550, r::Optional, d::RepeatCount.bounded(1)),
                      s:: N4.use(6560, r::Optional, d::RepeatCount.bounded(1)),
                      s::DTP.use(6570, r::Optional, d::RepeatCount.unbounded))),

                  d::LoopDef.build("2630", d::RepeatCount.unbounded,
                    s:: FC.use(6600, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTP.use(6700, r::Optional,  d::RepeatCount.unbounded),

                    d::LoopDef.build("2640", d::RepeatCount.unbounded,
                      s::INV.use(6000, r::Optional,  d::RepeatCount.bounded(1)),
                      s::DTP.use(6000, r::Optional,  d::RepeatCount.unbounded),
                      s::QTY.use(6000, r::Optional,  d::RepeatCount.unbounded),
                      s::ENT.use(6000, r::Optional,  d::RepeatCount.unbounded),
                      s::REF.use(6000, r::Optional,  d::RepeatCount.unbounded),
                      s::AMT.use(6000, r::Optional,  d::RepeatCount.bounded(20)),
                      s:: K3.use(6000, r::Optional,  d::RepeatCount.bounded(3)))),

                  d::LoopDef.build("2650", d::RepeatCount.unbounded,
                    s::AIN.use(6850, r::Optional,  d::RepeatCount.bounded(1)),
                    s::QTY.use(6860, r::Optional,  d::RepeatCount.unbounded),
                    s::DTP.use(6870, r::Optional,  d::RepeatCount.unbounded))),

              d::LoopDef.build("2700 LS", d::RepeatCount.bounded(1),
                s:: LS.use(6880, r::Optional, d::RepeatCount.bounded(1)),

                d::LoopDef.build("2700", d::RepeatCount.unbounded,
                  s:: LX.use(6881, r::Optional, d::RepeatCount.bounded(1)),

                  d::LoopDef.build("2750", d::RepeatCount.bounded(1),
                    s:: N1.use(6882, r::Optional, d::RepeatCount.bounded(1)),
                    s::REF.use(6883, r::Optional, d::RepeatCount.bounded(16)),
                    s::DTP.use(6884, r::Optional, d::RepeatCount.bounded(1)))),

                s:: LE.use(6885, r::Optional, d::RepeatCount.bounded(1)))),

            s::SE.use(6900, r::Mandatory, d::RepeatCount.bounded(1)),
            repeatable: false))

      end
    end
  end
end

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

            d::LoopDef.build("1000A", d::RepeatCount.bounded(1),
              s::N1.use(700, r::Mandatory, d::RepeatCount.bounded(1))),

            d::LoopDef.build("1000B", d::RepeatCount.bounded(1),
              s::N1.use(700, r::Mandatory, d::RepeatCount.bounded(1))),

            d::LoopDef.build("1000C", d::RepeatCount.bounded(2),
              s::N1.use(700, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("1100C", d::RepeatCount.bounded(1),
              s::ACT.use(1200, r::Optional, d::RepeatCount.bounded(1)))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("2000", d::RepeatCount.unbounded,
              s::INS.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::REF.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              s::REF.use(200, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(200, r::Optional,  d::RepeatCount.bounded(13)),
              s::DTP.use(250, r::Optional,  d::RepeatCount.bounded(24)),

              d::LoopDef.build("2100A", d::RepeatCount.bounded(1),
                s::NM1.use(300,  r::Mandatory, d::RepeatCount.bounded(1)),
                s::PER.use(400,  r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500,  r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(600,  r::Mandatory, d::RepeatCount.bounded(1)),
                s::DMG.use(800,  r::Optional,  d::RepeatCount.bounded(1)),
                s:: EC.use(1000, r::Optional,  d::RepeatCount.unbounded),
                s::ICM.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
                s::AMT.use(1200, r::Optional,  d::RepeatCount.bounded(7)),
                s::HLH.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                s::LUI.use(1500, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("2100B", d::RepeatCount.bounded(1),
                s::NM1.use(300, r::Optional, d::RepeatCount.bounded(1)),
                s::DMG.use(800, r::Optional, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2100C", d::RepeatCount.bounded(1),
                s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500, r::Mandatory, d::RepeatCount.bounded(1)),
                s:: N4.use(600, r::Mandatory, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2100D", d::RepeatCount.bounded(3),
                s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(600, r::Mandatory, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2100E", d::RepeatCount.bounded(3),
                s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(600, r::Mandatory, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2100F", d::RepeatCount.bounded(1),
                s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(600, r::Mandatory, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2100G", d::RepeatCount.bounded(13),
                s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(600, r::Mandatory, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2100H", d::RepeatCount.bounded(1),
                s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(600, r::Mandatory, d::RepeatCount.bounded(1))),

              d::LoopDef.build("2200", d::RepeatCount.unbounded,
                s::DSB.use(2000, r::Optional, d::RepeatCount.bounded(1)),
                s::DTP.use(2100, r::Optional, d::RepeatCount.bounded(2))),

              d::LoopDef.build("2300", d::RepeatCount.bounded(99),
                s:: HD.use(2600, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTP.use(2700, r::Mandatory, d::RepeatCount.bounded(6)),
                s::AMT.use(2800, r::Optional,  d::RepeatCount.bounded(9)),
                s::REF.use(2900, r::Optional,  d::RepeatCount.bounded(14)),
                s::REF.use(2900, r::Optional,  d::RepeatCount.bounded(1)),
                s::IDC.use(3000, r::Optional,  d::RepeatCount.bounded(3)),

                d::LoopDef.build("2310", d::RepeatCount.bounded(30),
                  s:: LX.use(3100, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(3200, r::Mandatory, d::RepeatCount.bounded(1)),
                  s:: N3.use(3500, r::Optional,  d::RepeatCount.bounded(2)),
                  s:: N4.use(3600, r::Mandatory, d::RepeatCount.bounded(1)),
                  s::PER.use(3700, r::Optional,  d::RepeatCount.bounded(2)),
                  s::PLA.use(3950, r::Optional,  d::RepeatCount.bounded(1))),

                d::LoopDef.build("2320", d::RepeatCount.bounded(5),
                  s::COB.use(4000, r::Optional, d::RepeatCount.bounded(1)),
                  s::REF.use(4050, r::Optional, d::RepeatCount.bounded(4)),
                  s::DTP.use(4070, r::Optional, d::RepeatCount.bounded(2)),

                  d::LoopDef.build("2330", d::RepeatCount.bounded(3),
                    s::NM1.use(4100, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N3.use(4300, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N4.use(4400, r::Mandatory, d::RepeatCount.bounded(1)),
                    s::PER.use(4500, r::Optional,  d::RepeatCount.bounded(1))))),

              d::LoopDef.build("2700", d::RepeatCount.bounded(1),
                s:: LS.use(6880, r::Optional, d::RepeatCount.bounded(1)),

                d::LoopDef.build("2710", d::RepeatCount.unbounded,
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

# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        HN277 = b.build("HN", "277", "Heath Care Information Status Notification",
          d::TableDef.header("1 - Header",
            s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BHT.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
            s::REF.use(300, r::Optional,  d::RepeatCount.bounded(10)),

            d::LoopDef.build("1000", d::RepeatCount.unbounded,
              s::NM1.use(400, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N2.use(500, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N3.use(600, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use(700, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(800, r::Optional,  d::RepeatCount.bounded(2)),
              s::PER.use(900, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("2000", d::RepeatCount.unbounded,
              s:: HL.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::SBR.use(200, r::Optional,  d::RepeatCount.bounded(1)),
              s::PAT.use(300, r::Optional,  d::RepeatCount.bounded(1)),
              s::DMG.use(400, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("2100", d::RepeatCount.unbounded,
                s::NM1.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(600, r::Optional,  d::RepeatCount.bounded(2)),
                s:: N4.use(700, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(800, r::Optional,  d::RepeatCount.bounded(1))),

              d::LoopDef.build("2200", d::RepeatCount.unbounded,
                s::TRN.use( 900, r::Optional,  d::RepeatCount.bounded(1)),
                s::STC.use(1000, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(1100, r::Optional,  d::RepeatCount.unbounded),
                s::DTP.use(1200, r::Optional,  d::RepeatCount.bounded(2)),
                s::QTY.use(1210, r::Optional,  d::RepeatCount.bounded(5)),
                s::AMT.use(1220, r::Optional,  d::RepeatCount.bounded(5)),

                d::LoopDef.build("2210", d::RepeatCount.unbounded,
                  s::PWK.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::PER.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N1.use(1500, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N3.use(1600, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N4.use(1700, r::Optional,  d::RepeatCount.bounded(1))),

                d::LoopDef.build("2220", d::RepeatCount.unbounded,
                  s::SVC.use(1800, r::Optional,  d::RepeatCount.bounded(1)),
                  s::STC.use(1900, r::Optional,  d::RepeatCount.unbounded),
                  s::REF.use(2000, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTP.use(2100, r::Optional,  d::RepeatCount.bounded(1)),

                  d::LoopDef.build("2225", d::RepeatCount.unbounded,
                    s::PWK.use(2200, r::Optional,  d::RepeatCount.bounded(1)),
                    s::PER.use(2300, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N1.use(2400, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N2.use(2500, r::Optional,  d::RepeatCount.bounded(1)),
                    s:: N3.use(2600, r::Optional,  d::RepeatCount.bounded(1)))))),

            s:: SE.use(2700, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

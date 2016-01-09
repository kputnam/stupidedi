module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FortyTen
        module TransactionSetDefs

          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          HP835 = d::TransactionSetDef.build("HP", "835",
            "Health Care Claim Payment/Advice",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BPR.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              s::TRN.use(400, r::Optional,  d::RepeatCount.bounded(1)),
              s::CUR.use(500, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(600, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use(600, r::Optional,  d::RepeatCount.bounded(1)),
              s::DTM.use(700, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("1000A", d::RepeatCount.bounded(1),
                s:: N1.use( 800, r::Mandatory, d::RepeatCount.bounded(1)),
                s:: N3.use(1000, r::Mandatory, d::RepeatCount.bounded(1)),
                s:: N4.use(1100, r::Mandatory, d::RepeatCount.bounded(1)),
                s::REF.use(1200, r::Optional,  d::RepeatCount.bounded(4)),
                s::PER.use(1300, r::Optional,  d::RepeatCount.bounded(1))),

              d::LoopDef.build("1000B", d::RepeatCount.bounded(1),
                s:: N1.use( 800, r::Mandatory, d::RepeatCount.bounded(1)),
                s:: N3.use(1000, r::Optional, d::RepeatCount.bounded(1)),
                s:: N4.use(1100, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(1200, r::Optional, d::RepeatCount.unbounded))),

            d::TableDef.detail("Table 2 - Detail",
              d::LoopDef.build("2000", d::RepeatCount.unbounded,
                s:: LX.use(30, r::Optional,  d::RepeatCount.bounded(1)),
                s::TS3.use(50, r::Optional,  d::RepeatCount.bounded(1)),
                s::TS2.use(70, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("2100", d::RepeatCount.unbounded,
                  s::CLP.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
                  s::CAS.use(200, r::Optional,  d::RepeatCount.bounded(99)),
                  s::NM1.use(300, r::Mandatory, d::RepeatCount.bounded(1)),
                  s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::NM1.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                  s::MIA.use(330, r::Optional,  d::RepeatCount.bounded(1)),
                  s::MOA.use(350, r::Optional,  d::RepeatCount.bounded(1)),
                  s::REF.use(400, r::Optional,  d::RepeatCount.bounded(5)),
                  s::REF.use(400, r::Optional,  d::RepeatCount.bounded(10)),
                  s::DTM.use(500, r::Optional,  d::RepeatCount.bounded(4)),
                  s::PER.use(600, r::Optional,  d::RepeatCount.bounded(3)),
                  s::AMT.use(620, r::Optional,  d::RepeatCount.bounded(14)),
                  s::QTY.use(640, r::Optional,  d::RepeatCount.bounded(15))),

                  d::LoopDef.build("2110", d::RepeatCount.bounded(999),
                    s::SVC.use( 700, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTM.use( 800, r::Optional,  d::RepeatCount.bounded(3)),
                    s::CAS.use( 900, r::Optional,  d::RepeatCount.bounded(99)),
                    s::REF.use(1000, r::Optional,  d::RepeatCount.bounded(7)),
                    s::REF.use(1000, r::Optional,  d::RepeatCount.bounded(10)),
                    s::AMT.use(1100, r::Optional,  d::RepeatCount.bounded(12)),
                    s::QTY.use(1200, r::Optional,  d::RepeatCount.bounded(6)),
                    s:: LQ.use(1300, r::Optional,  d::RepeatCount.bounded(99))))),

            d::TableDef.summary("Table 3 - Summary",
              s::PLB.use(100, r::Optional,  d::RepeatCount.unbounded),
              s:: SE.use(200, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end

module Stupidedi
  module Contrib
    module ThirtyTen
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PO850 = d::TransactionSetDef.build("PO", "850", "Purchase Order",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),          
            s::BEG.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::CUR.use( 40, r::Optional, d::RepeatCount.bounded(1)),
            s::FOB.use( 80, r::Optional,  d::RepeatCount.bounded(1)),
            s::ITD.use( 130, r::Optional,  d::RepeatCount.bounded(5)),
            s::DTM.use( 150, r::Optional,  d::RepeatCount.bounded(2)),
            s::TD5.use( 240, r::Optional,  d::RepeatCount.bounded(1)),
            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              s:: N9.use( 290, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              s:: N9.use( 291, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              s:: N9.use( 292, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("N9", d::RepeatCount.bounded(1),
              s:: N9.use( 330, r::Optional, d::RepeatCount.bounded(1)),
              s::MSG.use( 340, r::Optional,  d::RepeatCount.bounded(1000))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 310, r::Optional, d::RepeatCount.bounded(1)),
              s:: N2.use( 320, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N3.use( 330, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use( 340, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(10000),
              s::PO1.use(  10, r::Mandatory, d::RepeatCount.bounded(1)),
              
              d::LoopDef.build("PID", d::RepeatCount.unbounded,
                s::PID.use( 50, r::Optional,  d::RepeatCount.bounded(1))),

              d::LoopDef.build("N9", d::RepeatCount.bounded(1000),
                s:: N9.use( 330, r::Optional, d::RepeatCount.bounded(1)),
                s::MSG.use( 340, r::Optional,  d::RepeatCount.bounded(1000))))),

          d::TableDef.summary("Table 3 - Summary",
            s::CTT.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use( 30, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end
module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs

        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SH856 = d::TransactionSetDef.build("SH", "856", "Ship Notice/Manifest",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BSN.use( 200, r::Mandatory, d::RepeatCount.bounded(1)),
            s::DTM.use( 300, r::Mandatory, d::RepeatCount.bounded(10))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("HL", d::RepeatCount.bounded(200000),
              s:: HL.use( 200, r::Mandatory,  d::RepeatCount.bounded(1)),
              s::TD1.use(1000, r::Mandatory,  d::RepeatCount.bounded(20)),
              s::TD5.use(1100, r::Mandatory,  d::RepeatCount.bounded(12)),
              s::TD3.use(1200, r::Optional,   d::RepeatCount.bounded(12)),
              s::REF.use(1500, r::Mandatory,  d::RepeatCount.unbounded),
              s:: N1.use(3700, r::Mandatory,  d::RepeatCount.bounded(3)),
              s::LIN.use(6600, r::Mandatory,  d::RepeatCount.bounded(1)),
              s::SN1.use(6700, r::Mandatory,  d::RepeatCount.bounded(1)))),

          d::TableDef.summary("Table 4 - Summary",
            s::CTT.use(100, r::Optional,  d::RepeatCount.bounded(1)),
            s:: SE.use(200, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

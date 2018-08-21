# frozen_string_literal: true
module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs

        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SH856 = d::TransactionSetDef.build("SH", "856", "Ship Notice/Manifest",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BSN.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::DTM.use( 40, r::Optional,  d::RepeatCount.bounded(10))
          ),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("HL", d::RepeatCount.bounded(200000),
              s:: HL.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::MEA.use( 80, r::Optional,  d::RepeatCount.bounded(40)),
              s::TD1.use(110, r::Optional,  d::RepeatCount.bounded(20)),
              s::TD5.use(120, r::Optional,  d::RepeatCount.bounded(12)),
              s::TD3.use(130, r::Optional,  d::RepeatCount.bounded(12)),
              s::TD4.use(140, r::Optional,  d::RepeatCount.bounded(5)),
              s::REF.use(150, r::Optional,  d::RepeatCount.unbounded),
            ),
            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 310, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N3.use( 330, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use( 340, r::Optional,  d::RepeatCount.unbounded),
              s::REF.use( 350, r::Optional,  d::RepeatCount.bounded(12))),
            d::LoopDef.build("HL", d::RepeatCount.bounded(200),
              s:: N1.use( 310, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N1.use( 310, r::Optional,  d::RepeatCount.bounded(1)),              
              s::REF.use( 350, r::Optional,  d::RepeatCount.bounded(12))),

          ),

          d::TableDef.summary("Table 4 - Summary",
            s::CTT.use(100, r::Optional,  d::RepeatCount.bounded(1)),
            s:: SE.use(200, r::Mandatory, d::RepeatCount.bounded(1))
          )
        )

      end
    end
  end
end

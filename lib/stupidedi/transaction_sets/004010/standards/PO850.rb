# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PO850 = b.build("PO", "850", "Purchase Order",
          d::TableDef.header("1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BEG.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::CUR.use( 40, r::Optional,  d::RepeatCount.bounded(1)),
            s::REF.use( 50, r::Optional,  d::RepeatCount.unbounded),
            s::PER.use( 60, r::Optional,  d::RepeatCount.bounded(3)),
            s::DTM.use(150, r::Optional,  d::RepeatCount.bounded(10)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 310, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N3.use( 330, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use( 340, r::Optional,  d::RepeatCount.unbounded),
              s::REF.use( 350, r::Optional,  d::RepeatCount.bounded(12)))),

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(10000),
              s::PO1.use( 10, r::Mandatory, d::RepeatCount.bounded(1))),

            d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
              s::PID.use( 50, r::Optional,  d::RepeatCount.bounded(1))),

            d::LoopDef.build("SCH", d::RepeatCount.bounded(200),
              s::SCH.use( 295, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s::N1.use( 350, r::Optional, d::RepeatCount.bounded(1)),
              s::N3.use( 370, r::Optional,  d::RepeatCount.bounded(2)),
              s::N4.use( 380, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.summary("3 - Summary",
            d::LoopDef.build("CTT", d::RepeatCount.bounded(1),
              s::CTT.use( 10, r::Optional,  d::RepeatCount.bounded(1))),

            s:: SE.use( 30, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

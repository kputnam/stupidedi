# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SC832 = b.build("SC", "832", "Price/Sales Catalog",
          d::TableDef.header("1 - Header",
            s:: ST.use( 100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BCT.use( 200, r::Mandatory, d::RepeatCount.bounded(1)),
            s::REF.use( 500, r::Optional, d::RepeatCount.unbounded),
            s::DTM.use( 700, r::Optional, d::RepeatCount.bounded(10)),
            d::LoopDef.build("N1", d::RepeatCount.bounded(1),
              s::N1.use(1500, r::Optional, d::RepeatCount.bounded(1)))),

          d::TableDef.detail("2 - Products",
            d::LoopDef.build("LIN", d::RepeatCount.bounded(200000),
              s::LIN.use( 100, r::Optional,  d::RepeatCount.bounded(1)),
              s::DTM.use( 300, r::Optional,  d::RepeatCount.bounded(10)),
              s::REF.use( 400, r::Optional,  d::RepeatCount.unbounded),
              s::PID.use( 700, r::Optional,   d::RepeatCount.bounded(200)),
              s::PO4.use(1000, r::Mandatory,  d::RepeatCount.bounded(1)),
              d::LoopDef.build("CTP", d::RepeatCount.bounded(100),
                s::CTP.use(1700, r::Optional, d::RepeatCount.bounded(1))))),

          d::TableDef.summary("3 - Summary",
            s::CTT.use(100, r::Optional,  d::RepeatCount.bounded(1)),
            s:: SE.use(200, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

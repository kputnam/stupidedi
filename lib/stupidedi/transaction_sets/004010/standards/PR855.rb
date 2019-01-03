# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PR855 = b.build("PR", "855", "Purchase Order Ack",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BAK.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 310, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N3.use( 330, r::Optional,  d::RepeatCount.bounded(2)),
              s:: N4.use( 340, r::Optional,  d::RepeatCount.unbounded),
              s::REF.use( 350, r::Optional,  d::RepeatCount.bounded(12)))),

          d::TableDef.header("Table 2 - Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(10000),
              s::PO1.use( 10, r::Mandatory, d::RepeatCount.bounded(1)))),

          d::TableDef.header("Table 3 - Summary",
            d::LoopDef.build("CTT", d::RepeatCount.bounded(1),
              s::CTT.use( 10, r::Optional,  d::RepeatCount.bounded(1))),

            s:: SE.use( 30, r::Optional, d::RepeatCount.bounded(1))))

      end
    end
  end
end

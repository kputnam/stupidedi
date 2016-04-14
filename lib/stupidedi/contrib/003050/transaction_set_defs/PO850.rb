# frozen_string_literal: true
module Stupidedi
  module Contrib
    module ThirtyFifty
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PO850 = d::TransactionSetDef.build("PO", "850",
          "Purchase Order",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BEG.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::NTE.use( 30, r::Optional,  d::RepeatCount.bounded(10)),
            s::PER.use( 60, r::Optional,  d::RepeatCount.bounded(3)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 310, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.header("Table 2 - Detail",
            d::LoopDef.build("PO1", d::RepeatCount.bounded(10000),
              s::PO1.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),

              d::LoopDef.build("PID", d::RepeatCount.bounded(1000),
                s::PID.use( 50, r::Optional,  d::RepeatCount.bounded(1))),

              d::LoopDef.build("DTM", d::RepeatCount.bounded(1),
                s::DTM.use(210, r::Optional,  d::RepeatCount.bounded(10))),

              d::LoopDef.build("N9", d::RepeatCount.bounded(1000),
                s:: N9.use(330, r::Optional,  d::RepeatCount.bounded(1))))),


          d::TableDef.header("Table 3 - Summary",
            s::CTT.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use( 30, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

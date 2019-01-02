# frozen_string_literal: true
module Stupidedi
  module Contrib
    module ThirtyForty
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        WA142 = d::TransactionSetDef.build("WA", "142", "Product Service Claim",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BGN.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(4),
              s:: N1.use( 30, r::Mandatory, d::RepeatCount.bounded(1)),
              s::PER.use( 80, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("LX", d::RepeatCount.unbounded,
              s:: LX.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s:: N9.use( 20, r::Mandatory, d::RepeatCount.bounded(11)),

              d::LoopDef.build("LIN", d::RepeatCount.unbounded,
                s::LIN.use(  32, r::Mandatory, d::RepeatCount.bounded(1)),
                s::QTY.use(  50, r::Optional,  d::RepeatCount.bounded(2)),
                s::DTM.use(  60, r::Optional,  d::RepeatCount.unbounded),
                s::SSS.use( 100, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("PRR", d::RepeatCount.unbounded,
                s::PRR.use( 170, r::Mandatory, d::RepeatCount.bounded(1)),
                s::MSG.use( 210, r::Optional,  d::RepeatCount.unbounded)),

              d::LoopDef.build("REP", d::RepeatCount.unbounded,
                s::REP.use( 310, r::Mandatory, d::RepeatCount.bounded(1)),

                d::LoopDef.build("IT1", d::RepeatCount.unbounded,
                  s::IT1.use( 400, r::Optional,  d::RepeatCount.bounded(1)))),

              d::LoopDef.build("AMT", d::RepeatCount.bounded(1),
                s::AMT.use( 450, r::Optional,  d::RepeatCount.bounded(1))))),

          d::TableDef.summary("Table 3 - Summary",
            d::LoopDef.build("TDS", d::RepeatCount.bounded(1),
              s::TDS.use( 10, r::Optional,  d::RepeatCount.bounded(1))),

            s:: SE.use( 40, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SS862 = b.build("SS", "862", "Shipping Schedule",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BSS.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::DTM.use( 30, r::Optional, d::RepeatCount.bounded(10)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use( 50, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use( 90, r::Optional,  d::RepeatCount.bounded(12)),
              s::PER.use(100, r::Optional,  d::RepeatCount.bounded(3)))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("LIN", d::RepeatCount.bounded(10000),
              s::LIN.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::UIT.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
              s::REF.use( 50, r::Optional,  d::RepeatCount.bounded(12)),

              d::LoopDef.build("FST", d::RepeatCount.bounded(100),
                s::FST.use( 80, r::Optional, d::RepeatCount.bounded(1)),

                d::LoopDef.build("JIT", d::RepeatCount.bounded(96),
                  s::JIT.use(110, r::Optional,  d::RepeatCount.bounded(1)),
                  s::REF.use(120, r::Optional,  d::RepeatCount.bounded(500)))))),

          d::TableDef.detail("Summary",
            s::CTT.use(10, r::Optional,  d::RepeatCount.bounded(1)),
            s:: SE.use(20, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

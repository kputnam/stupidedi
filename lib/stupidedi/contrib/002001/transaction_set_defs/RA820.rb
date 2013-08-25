module Stupidedi
  module Contrib
    module TwoThousandOne
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        RA820 = d::TransactionSetDef.build("RA", "820", "Payment Order/Remittance Advice",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),          
            s::BPS.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::REF.use( 50, r::Mandatory, d::RepeatCount.bounded(1)),
            s::DTM.use( 60, r::Optional,  d::RepeatCount.bounded(10)),
            d::LoopDef.build("N1", d::RepeatCount.bounded(1),
              s:: N1.use(  70, r::Mandatory, d::RepeatCount.bounded(1)),
          
          d::TableDef.detail("Table 2 - Detail",
            s:: LS.use(  10, r::Mandatory, d::RepeatCount.bounded(1)),
            d::LoopDef.build("N1", d::RepeatCount.bounded(1),
              s:: N1.use(  20, r::Mandatory, d::RepeatCount.bounded(1)),
              d::LoopDef.build("RMT", d::RepeatCount.bounded(1),
                s::RMT.use(  30, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(  50, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(  51, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(  52, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(  53, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTM.use(  60, r::Optional,  d::RepeatCount.bounded(2)))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use(  21, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use(  22, r::Optional, d::RepeatCount.bounded(1))),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use(  22, r::Optional, d::RepeatCount.bounded(1))),

              d::LoopDef.build("RMT", d::RepeatCount.bounded(199999),
                s::RMT.use(  30, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(  50, r::Optional, d::RepeatCount.bounded(1)),              
                s::REF.use(  50, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(  50, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(  50, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(  50, r::Optional, d::RepeatCount.bounded(1)),
                s:: LE.use(  70, r::Optional, d::RepeatCount.bounded(200))),

          d::TableDef.summary("Table 3 - Summary",
            s:: SE.use( 10, r::Mandatory, d::RepeatCount.bounded(1)))))

      end
    end
  end
end
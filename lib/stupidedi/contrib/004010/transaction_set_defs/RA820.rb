# frozen_string_literal: true

module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs

        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        RA820 = d::TransactionSetDef.build("RA", "820", "Payment Order/Remittance Advice",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BPR.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::NTE.use(30, r::Optional, d::RepeatCount.bounded(1)),
            s::TRN.use(35, r::Optional, d::RepeatCount.bounded(1)),
            s::REF.use( 50, r::Optional, d::RepeatCount.bounded(5)),
            s::DTM.use( 60, r::Optional,  d::RepeatCount.bounded(1)),
            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              s::N1.use(  70, r::Optional, d::RepeatCount.bounded(1)),
              s::N2.use(  80, r::Optional, d::RepeatCount.bounded(1)),
              s::N3.use(  90, r::Optional, d::RepeatCount.bounded(1)),
              s::N4.use(  100, r::Optional, d::RepeatCount.bounded(1)),
              s::PER.use(  120, r::Optional, d::RepeatCount.bounded(1))
            )
          ),

          d::TableDef.detail("Table 2 - Detail",

              # s:: ENT.use(  10, r::Optional, d::RepeatCount.bounded(1)),
              #   s::RMR.use(  150, r::Optional,  d::RepeatCount.bounded(1))
          ),


          d::TableDef.summary("Table 3 - Summary",
            s:: SE.use( 10, r::Mandatory, d::RepeatCount.bounded(1))
          )
        )

      end
    end
  end
end

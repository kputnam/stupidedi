module Stupidedi
  module Contrib
    module TwoThousandOne
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        FA997 = d::TransactionSetDef.build("FA", "997", "Functional Acknowledgment",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use(10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::AK1.use(20, r::Mandatory, d::RepeatCount.bounded(1)),

            d::LoopDef.build("AK2", d::RepeatCount.bounded(999999),
              s:: AK2.use( 30, r::Optional, d::RepeatCount.bounded(1)),

              d::LoopDef.build("AK3", d::RepeatCount.bounded(999999),
                s::AK3.use(40, r::Optional, d::RepeatCount.bounded(1)),
                s::AK4.use(50, r::Optional, d::RepeatCount.bounded(99))),

              s::AK5.use(60, r::Mandatory, d::RepeatCount.bounded(1))),

            s::AK9.use(70, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(80, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

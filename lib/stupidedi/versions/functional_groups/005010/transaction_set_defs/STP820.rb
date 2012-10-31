module Stupidedi
  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          STP820 = d::TransactionSetDef.build("RA", "820",
            "Payment Order/Remittance Advice",

            d::TableDef.header("Table 1 - Header",
              s::ST .use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BPR.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              s::TRN.use(350, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("N1", d::RepeatCount.bounded(1),
                s::N1.use( 650, r::Optional,  d::RepeatCount.bounded(1)),
                s::N1.use( 700, r::Optional,  d::RepeatCount.bounded(1)))),


            d::TableDef.detail("Table 2 - Detail",
              d::LoopDef.build("ENT", d::RepeatCount.unbounded,
                s::ENT.use( 100, r::Mandatory,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("ENT/RMR", d::RepeatCount.unbounded,
                  s::RMR.use(1500, r::Mandatory,  d::RepeatCount.bounded(1)),
                  s::REF .use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTM .use(1800, r::Optional,  d::RepeatCount.bounded(1))),

                  d::LoopDef.build("ENT/RMR/ADX", d::RepeatCount.bounded(1),
                    s::ADX.use(2100, r::Optional,  d::RepeatCount.bounded(1)))

            )),

            d::TableDef.summary("Table 3 - Summary",
              s:: SE.use( 100, r::Mandatory, d::RepeatCount.bounded(1)))
            )

        end
      end
    end
  end
end

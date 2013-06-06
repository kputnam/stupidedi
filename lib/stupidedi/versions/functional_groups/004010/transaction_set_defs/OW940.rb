module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module TransactionSetDefs
          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          OW940 = d::TransactionSetDef.build("OW", "940", "Warehouse Shipping Order",

            d::TableDef.header("Table 1 - Header",
              s::ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::W05.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
              d::LoopDef.build("N1", d::RepeatCount.bounded(10),
                s::N1.use( 40, r::Mandatory,  d::RepeatCount.bounded(1)),
                s::N2.use( 50, r::Optional, d::RepeatCount.bounded(2)),
                s::N3.use( 60, r::Optional, d::RepeatCount.bounded(2)),
                s::N4.use( 70, r::Optional, d::RepeatCount.bounded(1))
              ),
              s::N9.use( 90, r::Optional, d::RepeatCount.bounded(10)),
              s::G62.use( 110, r::Optional,  d::RepeatCount.bounded(10)),
              s::NTE.use( 120, r::Optional,  d::RepeatCount.bounded(1)),
              s::W66.use( 140, r::Mandatory ,  d::RepeatCount.bounded(1))
            ),


            d::TableDef.header("Table 2 - Detail",
              d::LoopDef.build("LX", d::RepeatCount.bounded(9999),
                s::LX.use( 05, r::Mandatory, d::RepeatCount.bounded(1))
              ),
              d::LoopDef.build("W01", d::RepeatCount.bounded(9999),
                s::W01.use( 20, r::Mandatory,  d::RepeatCount.bounded(1)),
                s::N9.use( 40, r::Optional, d::RepeatCount.bounded(200)),
                s::W20.use( 50, r::Mandatory,  d::RepeatCount.bounded(1))
              )
            ),

            d::TableDef.header("Table 3 - Summary",
              s::W76.use( 10, r::Mandatory,  d::RepeatCount.bounded(1)),
              s::SE.use( 20, r::Mandatory, d::RepeatCount.bounded(1))
            )

          )
        
        end
      end
    end
  end
end

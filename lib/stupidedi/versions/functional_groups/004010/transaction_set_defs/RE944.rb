module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module TransactionSetDefs
          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          RE944 =  d::TransactionSetDef.build("RE", "944", "Warehouse Stock Transfer Receipt Advice",
            
            d::TableDef.header("Table 1 - Header",
              s::ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::W17.use(20, r::Mandatory, d::RepeatCount.bounded(1)),
              d::LoopDef.build("N1", d::RepeadCount.bounded(10),
                s::N1.use( 40, r::Mandatory,  d::RepeatCount.bounded(1)),
                s::N1.use( 40, r::Mandatory,  d::RepeatCount.bounded(1))
              ),
              s::W08.use(130, r::Optional ,  d::RepeatCount.bounded(1))
            ),

            d::TableDef.header("Table 2 - Detail",
              d::LoopDef.build("W07", d::RepeatCount.bounded(9999),
                s::W07.use(220, r::Mandatory, d::RepeatCount.bounded(1)),
                s::G69.use(230, r::Mandatory, d::RepeatCount.bounded(5)),
                s::N9.use(240, r::Mandatory, d::RepeatCount.bounded(200)),
                s::N9.use(240, r::Mandatory, d::RepeatCount.bounded(200))
              )
            ),

            d::TableDef.header("Table 3 - Summary",
              s::W14.use( 10, r::Mandatory,  d::RepeatCount.bounded(1)),
              s::SE.use(30, r::Mandatory, d::RepeatCount.bounded(1))
            )
          )
        end
      end
    end
  end
end

                

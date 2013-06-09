module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SW945 = d::TransactionSetDef.build("SW", "945",
          "Warehouse Shipping Advice",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::W06.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              s:: N1.use( 40, r::Mandatory, d::RepeatCount.bounded(1)),
              s:: N3.use( 60, r::Optional,  d::RepeatCount.bounded(1)),
              s:: N4.use( 70, r::Optional,  d::RepeatCount.bounded(1))),

            s:: N9.use( 90, r::Optional,  d::RepeatCount.bounded(10)),
            s::G62.use(110, r::Optional,  d::RepeatCount.bounded(5)),
            s::NTE.use(120, r::Optional,  d::RepeatCount.bounded(20)),
            s::W27.use(130, r::Optional,  d::RepeatCount.bounded(1))),

          d::TableDef.header("Table 2 - Detail",
            d::LoopDef.build("LX", d::RepeatCount.bounded(9999),
              s:: LX.use(  5, r::Mandatory, d::RepeatCount.bounded(1)),
              s::MAN.use( 10, r::Mandatory, d::RepeatCount.bounded(1))),

            d::LoopDef.build("W12", d::RepeatCount.bounded(9999),
              s::W12.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
              s::G69.use( 30, r::Optional,  d::RepeatCount.bounded(5)),
              s:: N9.use( 40, r::Optional,  d::RepeatCount.bounded(200)))),

          d::TableDef.header("Table 3 - Summary",
            s::W03.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use( 30, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

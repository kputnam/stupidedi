# frozen_string_literal: true
module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        IM210 = d::TransactionSetDef.build("IM", "210",
          "Motor Carrier Freight Details and Invoice",

          d::TableDef.header("Heading",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: B3.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: C3.use( 40, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: N9.use( 60, r::Optional,  d::RepeatCount.bounded(300)),
            s::G62.use( 70, r::Optional,  d::RepeatCount.bounded(6)),
            s:: R3.use( 80, r::Optional,  d::RepeatCount.bounded(12)),
            s:: H3.use( 90, r::Optional,  d::RepeatCount.bounded(6)),

            d::LoopDef.build("0100", d::RepeatCount.bounded(5),
              s:: N1.use(110, r::Mandatory,  d::RepeatCount.bounded(1)),
              s:: N3.use(130, r::Mandatory,  d::RepeatCount.bounded(2)),
              s:: N4.use(140, r::Mandatory,  d::RepeatCount.bounded(1)),
              s:: N9.use(150, r::Optional,   d::RepeatCount.bounded(5)))),

            d::LoopDef.build("0200", d::RepeatCount.bounded(10),
              s:: N7.use(160, r::Mandatory,  d::RepeatCount.bounded(1))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("0300", d::RepeatCount.unbounded,
              s:: S5.use(10, r::Mandatory, d::RepeatCount.unbounded),
              s::G62.use(30,  r::Optional,  d::RepeatCount.unbounded),

              d::LoopDef.build("0310", d::RepeatCount.unbounded,
                s:: N1.use(70, r::Mandatory, d::RepeatCount.unbounded),
                s:: N3.use(90, r::Mandatory, d::RepeatCount.unbounded),
                s:: N4.use(100, r::Mandatory, d::RepeatCount.unbounded)
              )
            )
          ),

          d::TableDef.detail("Detail",
            d::LoopDef.build("0400", d::RepeatCount.unbounded,
              s:: LX.use(120, r::Mandatory, d::RepeatCount.bounded(1)),
              s:: N9.use(130, r::Mandatory, d::RepeatCount.bounded(5)),
              s:: L5.use(140, r::Optional,  d::RepeatCount.bounded(30)),
              s:: L0.use(170, r::Optional,  d::RepeatCount.bounded(10)),
              s:: L1.use(180, r::Optional,  d::RepeatCount.bounded(10)),
              s:: L4.use(190, r::Optional,  d::RepeatCount.bounded(10)),
              s:: L7.use(200, r::Optional,  d::RepeatCount.bounded(10)))),

          d::TableDef.detail("Summary",
            s:: L3.use(10, r::Optional,  d::RepeatCount.bounded(1)),
            s:: SE.use(20, r::Mandatory, d::RepeatCount.bounded(1))))
      end
    end
  end
end

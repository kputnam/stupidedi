module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        QM214 = d::TransactionSetDef.build("QM", "214",
          "Transportation Carrier Shipment Status Message",

          d::TableDef.header("Heading",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::B10.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::L11.use( 30, r::Optional , d::RepeatCount.bounded(300)),

            d::LoopDef.build("0100", d::RepeatCount.bounded(10),
              s:: N1.use( 50, r::Optional , d::RepeatCount.bounded(1)),
              s:: N3.use( 70, r::Optional , d::RepeatCount.bounded(2)),
              s:: N4.use( 80, r::Optional , d::RepeatCount.bounded(1))),

            d::LoopDef.build("0150", d::RepeatCount.bounded(12),
              s::MS3.use(120, r::Optional , d::RepeatCount.bounded(1))),

            d::LoopDef.build("0200", d::RepeatCount.bounded(999999),
              s:: LX.use(130, r::Mandatory, d::RepeatCount.bounded(1)),

              d::LoopDef.build("0205", d::RepeatCount.bounded(10),
                s::AT7.use(140, r::Mandatory, d::RepeatCount.bounded(1)),
                s::MS1.use(143, r::Optional , d::RepeatCount.bounded(1)),
                s::MS2.use(146, r::Optional , d::RepeatCount.bounded(1))),

              s::L11.use(150, r::Optional , d::RepeatCount.bounded(10)),
              s::AT8.use(200, r::Optional , d::RepeatCount.bounded(10))),

            s:: SE.use(610, r::Mandatory, d::RepeatCount.bounded(1))))
      end
    end
  end
end

module Stupidedi
  module Contrib
    module ThirtyTen
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PS830 = d::TransactionSetDef.build("PS", "830", "Planning Schedule with Release Capability",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BFR.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use(  90, r::Optional, d::RepeatCount.bounded(1)),
              s::PER.use( 140, r::Optional, d::RepeatCount.bounded(3)))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("LIN", d::RepeatCount.bounded(10000),
              s::LIN.use( 010, r::Mandatory, d::RepeatCount.bounded(1)),
              s::UIT.use( 020, r::Mandatory, d::RepeatCount.bounded(1)),
              s::PID.use( 80, r::Optional, d::RepeatCount.bounded(1)),

              d::LoopDef.build("SDP", d::RepeatCount.bounded(260),
                s::SDP.use( 290, r::Mandatory, d::RepeatCount.bounded(1)),
                s::FST.use( 300, r::Mandatory, d::RepeatCount.bounded(260))),

              s::MAN.use( 390, r::Optional, d::RepeatCount.bounded(10)))),

          d::TableDef.summary("Table 3 - Summary",
            s::CTT.use(010, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(020, r::Mandatory, d::RepeatCount.bounded(1))))


      end
    end
  end
end

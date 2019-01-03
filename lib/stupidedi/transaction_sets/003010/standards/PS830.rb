# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module ThirtyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PS830 = b.build("PS", "830", "Planning Schedule with Release Capability",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BFR.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            # s::NTE.use( 30, r::Optional, d::RepeatCount.bounded(100)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(200),
              s:: N1.use(  90, r::Optional, d::RepeatCount.bounded(1)))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("LIN", d::RepeatCount.bounded(10000),
              s::LIN.use( 010, r::Mandatory, d::RepeatCount.bounded(1)),
              s::UIT.use( 020, r::Mandatory, d::RepeatCount.bounded(1)),
              s::PID.use(  80, r::Optional, d::RepeatCount.bounded(1000)),

              d::LoopDef.build("N1", d::RepeatCount.bounded(200),
                s:: N1.use( 210, r::Optional, d::RepeatCount.bounded(1))),

              d::LoopDef.build("SDP", d::RepeatCount.bounded(100),
                s::SDP.use( 290, r::Optional, d::RepeatCount.bounded(1)),
                s::FST.use( 301, r::Optional, d::RepeatCount.bounded(1)),
                d::LoopDef.build("NTE", d::RepeatCount.bounded(100),
                  s::NTE.use(  30, r::Optional, d::RepeatCount.bounded(1)),
                  s::FST.use( 300, r::Optional, d::RepeatCount.bounded(260)))),

              # s::SDP.use( 291, r::Optional, d::RepeatCount.bounded(1)),
              # s::NTE.use(  31, r::Optional, d::RepeatCount.bounded(1)),

              d::LoopDef.build("SHP", d::RepeatCount.bounded(25),
                s::SHP.use( 330, r::Optional, d::RepeatCount.bounded(1))))),

          d::TableDef.summary("Table 3 - Summary",
            s::CTT.use(010, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(020, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

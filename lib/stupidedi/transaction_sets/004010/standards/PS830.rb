# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        PS830 = b.build("PS", "830", "Planning Schedule with Release Capability",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BFR.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::REF.use( 50, r::Optional,  d::RepeatCount.bounded(12)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(2),
              s:: N1.use( 230, r::Optional,  d::RepeatCount.bounded(1)))),

          d::TableDef.header("Table 2 - Detail",
            d::LoopDef.build("LIN", d::RepeatCount.unbounded,
              s::LIN.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::UIT.use( 20, r::Optional,  d::RepeatCount.bounded(1)),
              s::PID.use( 80, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("N1", d::RepeatCount.bounded(1),
                s::N1.use( 320, r::Optional,  d::RepeatCount.bounded(1))),

              d::LoopDef.build("SDP", d::RepeatCount.bounded(1),
                s::SDP.use( 450, r::Optional,  d::RepeatCount.bounded(1)),
                s::FST.use( 460, r::Optional,  d::RepeatCount.bounded(6))),

              d::LoopDef.build("SHP", d::RepeatCount.bounded(1),
                s::SHP.use( 470, r::Optional,  d::RepeatCount.bounded(1))))),

          d::TableDef.header("Table 3 - Summary",
            s::CTT.use( 10, r::Optional,  d::RepeatCount.bounded(1)),
            s:: SE.use( 20, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module TwoThousandOne
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SH856 = b.build("SH", "856", "Ship Notice/Manifest",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BSN.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::DTM.use( 40, r::Optional,  d::RepeatCount.bounded(10))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("HL", d::RepeatCount.bounded(1),
              s:: HL.use(  50, r::Mandatory, d::RepeatCount.bounded(1)),
              s::LIN.use(  60, r::Optional,  d::RepeatCount.bounded(1)),
              s::SN1.use(  80, r::Optional,  d::RepeatCount.bounded(1)),
              s::PO4.use( 110, r::Optional,  d::RepeatCount.bounded(1)),
              s::MEA.use( 130, r::Optional,  d::RepeatCount.bounded(1)),
              s::TD1.use( 160, r::Optional,  d::RepeatCount.bounded(1)),
              s::TD3.use( 180, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use( 200, r::Optional,  d::RepeatCount.bounded(2)),

              d::LoopDef.build("N1", d::RepeatCount.bounded(200),
                s:: N1.use(270, r::Optional, d::RepeatCount.bounded(1))))),

          d::TableDef.summary("Table 3 - Summary",
            s::CTT.use(380, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(390, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

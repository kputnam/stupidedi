# frozen_string_literal: true
module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        SQ866 = d::TransactionSetDef.build("SQ", "866",
          "Production Sequence",

          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BSS.use( 20, r::Mandatory, d::RepeatCount.bounded(1))),

          d::TableDef.header("Table 2 - Detail",
            d::LoopDef.build("DTM", d::RepeatCount.bounded(100),
              s::DTM.use(110, r::Mandatory, d::RepeatCount.bounded(1)),

              d::LoopDef.build("LIN", d::RepeatCount.unbounded,
                s::LIN.use(150, r::Optional, d::RepeatCount.bounded(1)),
                s::REF.use(160, r::Optional,  d::RepeatCount.unbounded),
                s::QTY.use(170, r::Optional,  d::RepeatCount.bounded(1))))),

          d::TableDef.header("Table 3 - Summary",
            s::CTT.use(195, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(200, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

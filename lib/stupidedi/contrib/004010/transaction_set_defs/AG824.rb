# frozen_string_literal: true

module Stupidedi
  module Contrib
    module FortyTen
      module TransactionSetDefs

        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        AG824 = d::TransactionSetDef.build("AG", "824", "Application Advice",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use(10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BGN.use(20, r::Mandatory, d::RepeatCount.bounded(1)),
            d::LoopDef.build("N1", d::RepeatCount.unbounded,
              s::N1.use(30, r::Mandatory, d::RepeatCount.bounded(1)),
              s::PER.use(80, r::Mandatory, d::RepeatCount.bounded(3)),
            )
          ),
          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("OTI", d::RepeatCount.unbounded,
              s::OTI.use(10, r::Mandatory,  d::RepeatCount.bounded(1)),
              s::AMT.use(50, r::Optional,  d::RepeatCount.unbounded),
              s::QTY.use(60, r::Optional,  d::RepeatCount.unbounded),
              d::LoopDef.build("OTI", d::RepeatCount.unbounded,
                s::OTI.use(65, r::Optional,  d::RepeatCount.bounded(1)),
                s::AMT.use(67, r::Optional,  d::RepeatCount.bounded(1)),
                s::TED.use(70, r::Optional,  d::RepeatCount.bounded(1)),
              ),
            ),
             s:: SE.use(90, r::Mandatory, d::RepeatCount.bounded(1))
          )
        )

      end
    end
  end
end

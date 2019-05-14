# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        QO315 = b.build("QO", "315", "Container Status Updates",
          d::TableDef.header("1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: B4.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: N9.use( 30, r::Optional,  d::RepeatCount.unbounded),
            s:: Q2.use( 40, r::Optional,  d::RepeatCount.bounded(1)),

            d::LoopDef.build("R4", d::RepeatCount.unbounded,
              s:: R4.use( 60, r::Mandatory,  d::RepeatCount.bounded(1)),
              s:: DTM.use( 70, r::Optional,  d::RepeatCount.unbounded))))
      end
    end
  end
end

# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        GF990 = b.build("GF", "990", "Response to a Load Tender",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: B1.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: N9.use( 30, r::Optional,  d::RepeatCount.bounded(1)),
            s:: K1.use( 60, r::Optional,  d::RepeatCount.bounded(10)),
            s:: SE.use( 70, r::Mandatory, d::RepeatCount.bounded(1))))
      end
    end
  end
end

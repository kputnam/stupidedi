# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        AR943 = b.build("AR", "943", "Warehouse Stock Transfer",
          d::TableDef.header("1 - Header",
            s:: ST.use( 10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::W06.use( 20, r::Mandatory, d::RepeatCount.bounded(1)),

            d::LoopDef.build("N1", d::RepeatCount.bounded(10),
              s:: N1.use(140, r::Mandatory,  d::RepeatCount.bounded(1))),

            s::G62.use(110, r::Optional,  d::RepeatCount.bounded(2)),
            s::W27.use(130, r::Mandatory, d::RepeatCount.bounded(1))),

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("W04", d::RepeatCount.bounded(10000),
              s::W04.use(220, r::Mandatory, d::RepeatCount.bounded(1)),
              s:: N9.use(240, r::Optional,  d::RepeatCount.bounded(2)))),

          d::TableDef.summary("3 - Summary",
            s::W03.use(10, r::Mandatory, d::RepeatCount.bounded(1)),
            s:: SE.use(30, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

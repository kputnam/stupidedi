# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        HS270 = b.build("HS", "270", "Eligibility, Coverage, or Benefit Inquiry",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BHT.use(200, r::Mandatory, d::RepeatCount.bounded(1))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("2000", d::RepeatCount.unbounded,
              s:: HL.use( 100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::TRN.use( 200, r::Optional,  d::RepeatCount.bounded(9)),

              d::LoopDef.build("2100", d::RepeatCount.unbounded,
                s::NM1.use( 300, r::Mandatory, d::RepeatCount.bounded(1)),
                s::REF.use( 400, r::Optional,  d::RepeatCount.bounded(9)),
                s:: N2.use( 500, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use( 600, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use( 700, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use( 800, r::Optional,  d::RepeatCount.bounded(3)),
                s::PRV.use( 900, r::Optional,  d::RepeatCount.bounded(1)),
                s::DMG.use(1000, r::Optional,  d::RepeatCount.bounded(1)),
              # s::INS.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
                s:: HI.use(1150, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTP.use(1200, r::Optional,  d::RepeatCount.bounded(9)),
              # s::MPI.use(1250, r::Optional,  d::RepeatCount.bounded(9)),

              # d::LoopDef.build("2110", d::RepeatCount.bounded(99),
              # # s:: EQ.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
              #   s::AMT.use(1350, r::Optional,  d::RepeatCount.bounded(2)),
              # # s::VEH.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
              # # s::PDR.use(1500, r::Optional,  d::RepeatCount.bounded(1)),
              # # s::PDP.use(1600, r::Optional,  d::RepeatCount.bounded(1)),
              # # s::III.use(1700, r::Optional,  d::RepeatCount.bounded(10)),
              #   s::REF.use(1900, r::Optional,  d::RepeatCount.bounded(1)),
              #   s::DTP.use(2000, r::Optional,  d::RepeatCount.bounded(9))))),
                  )),

            s:: SE.use(2100, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

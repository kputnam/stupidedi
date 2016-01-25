# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Versions
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          HR276 = d::TransactionSetDef.build("HR", "276",
            "Health Care Claim Status Request",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BHT.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              s::REF.use(300, r::Optional,  d::RepeatCount.bounded(10)),

              d::LoopDef.build("1000", d::RepeatCount.unbounded,
                s::NM1.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N2.use(500, r::Optional,  d::RepeatCount.bounded(2)),
                s:: N3.use(600, r::Optional,  d::RepeatCount.bounded(2)),
                s:: N4.use(700, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(800, r::Optional,  d::RepeatCount.bounded(2)),
                s::PER.use(900, r::Optional,  d::RepeatCount.bounded(1)))),

            d::TableDef.detail("Table 2 - Detail",
              d::LoopDef.build("2000", d::RepeatCount.unbounded,
                s:: HL.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
                s::SBR.use(200, r::Optional,  d::RepeatCount.bounded(1)),
                s::PAT.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                s::DMG.use(400, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("2100", d::RepeatCount.unbounded,
                  s::NM1.use(500, r::Optional,  d::RepeatCount.bounded(1)),
                  s:: N3.use(600, r::Optional,  d::RepeatCount.bounded(2)),
                  s:: N4.use(700, r::Optional,  d::RepeatCount.bounded(1)),
                  s::PER.use(800, r::Optional,  d::RepeatCount.bounded(1))),

                d::LoopDef.build("2200", d::RepeatCount.unbounded,
                  s::TRN.use( 900, r::Optional,  d::RepeatCount.bounded(1)),
                  s::REF.use(1000, r::Optional,  d::RepeatCount.bounded(9)),
                  s::AMT.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTP.use(1200, r::Optional,  d::RepeatCount.bounded(2)),

                  d::LoopDef.build("2210", d::RepeatCount.unbounded,
                    s::SVC.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
                    s::REF.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
                    s::DTP.use(1500, r::Optional,  d::RepeatCount.bounded(1))))),

              s:: SE.use(1600, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end

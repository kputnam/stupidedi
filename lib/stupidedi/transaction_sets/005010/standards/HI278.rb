# frozen_string_literal: true
module Stupidedi
  module TransactionSets
    module FiftyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        HI278 = b.build("HI", "278", "Health Care Services Review Information",
          d::TableDef.header("Table 1 - Header",
            s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
            s::BHT.use(200, r::Mandatory, d::RepeatCount.bounded(1))),

          d::TableDef.detail("Table 2 - Detail",
            d::LoopDef.build("HL", d::RepeatCount.unbounded,
              s:: HL.use( 100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::TRN.use( 200, r::Optional,  d::RepeatCount.bounded(9)),
              s::AAA.use( 300, r::Optional,  d::RepeatCount.bounded(9)),
              s:: UM.use( 400, r::Optional,  d::RepeatCount.bounded(1)),
              s::HCR.use( 500, r::Optional,  d::RepeatCount.bounded(1)),
              s::REF.use( 600, r::Optional,  d::RepeatCount.bounded(9)),
              s::DTP.use( 700, r::Optional,  d::RepeatCount.bounded(9)),
              s:: HI.use( 800, r::Optional,  d::RepeatCount.bounded(1)),
              s::SV1.use( 810, r::Optional,  d::RepeatCount.bounded(1)),
              s::SV2.use( 820, r::Optional,  d::RepeatCount.bounded(1)),
              s::SV3.use( 830, r::Optional,  d::RepeatCount.bounded(1)),
              s::TOO.use( 840, r::Optional,  d::RepeatCount.bounded(32)),
              s::HSD.use( 900, r::Optional,  d::RepeatCount.bounded(1)),
              s::CRC.use(1000, r::Optional,  d::RepeatCount.bounded(9)),
              s::CL1.use(1100, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR1.use(1200, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR2.use(1300, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR4.use(1350, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR5.use(1400, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR6.use(1500, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR7.use(1520, r::Optional,  d::RepeatCount.bounded(1)),
              s::CR8.use(1530, r::Optional,  d::RepeatCount.bounded(1)),
              s::PWK.use(1550, r::Optional,  d::RepeatCount.unbounded),
              s::MSG.use(1600, r::Optional,  d::RepeatCount.bounded(1)),

              d::LoopDef.build("HL/NM1", d::RepeatCount.unbounded,
                s::NM1.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s::REF.use(1700, r::Optional,  d::RepeatCount.bounded(9)),
                s:: N2.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N3.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s:: N4.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s::PER.use(1700, r::Optional,  d::RepeatCount.bounded(3)),
                s::AAA.use(1700, r::Optional,  d::RepeatCount.bounded(9)),
                s::PRV.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s::DMG.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s::INS.use(1700, r::Optional,  d::RepeatCount.bounded(1)),
                s::DTP.use(1700, r::Optional,  d::RepeatCount.bounded(9))))),

          d::TableDef.summary("Table 3 - Summary",
            s:: SE.use(2700, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

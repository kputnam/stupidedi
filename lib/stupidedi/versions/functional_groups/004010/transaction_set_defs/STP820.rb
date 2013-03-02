module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module TransactionSetDefs

          d = Schema

          # TODO: We're borrowing from 5010 until we have 4010 segment defs
          r = FiftyTen::SegmentReqs
          s = FiftyTen::SegmentDefs

          # TODO: This is actually a transcription of a 4010 implementation
          # *guide*, it's not a transaction set definition.
          #
          # http://www.epaynetwork.com/cms/documents/001762.pdf
          STP820 = d::TransactionSetDef.build("RA", "820",
            "Payment Order/Remittance Advice",

            d::TableDef.header("Table 1 - Header",
              s::ST .use(10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::BPR.use(20, r::Mandatory, d::RepeatCount.bounded(1)),
              s::TRN.use(35, r::Mandatory, d::RepeatCount.bounded(1)),

              d::LoopDef.build("N1", d::RepeatCount.bounded(1),
                s::N1.use(65, r::Mandatory, d::RepeatCount.bounded(1)),
                s::N1.use(70, r::Mandatory, d::RepeatCount.bounded(1)))),

            d::TableDef.detail("Table 2 - Detail",
              d::LoopDef.build("ENT", d::RepeatCount.unbounded,
                s::ENT.use(10, r::Mandatory, d::RepeatCount.bounded(1)),

                d::LoopDef.build("RMR", d::RepeatCount.unbounded,
                  s::RMR.use(150, r::Mandatory, d::RepeatCount.bounded(1)),
                  s::REF.use(170, r::Optional,  d::RepeatCount.bounded(1)),
                  s::DTM.use(180, r::Optional,  d::RepeatCount.bounded(1)),

                  d::LoopDef.build("ADX", d::RepeatCount.bounded(1),
                    s::ADX.use(210, r::Optional, d::RepeatCount.bounded(1)))))),

            d::TableDef.summary("Table 3 - Summary",
              s::SE.use(100, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end

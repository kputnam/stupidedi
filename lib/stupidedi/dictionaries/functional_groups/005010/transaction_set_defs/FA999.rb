module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module TransactionSetDefs

          d = Schema
          e = Envelope
          r = SegmentReqs
          s = SegmentDefs

          FA999 = e::TransactionSetDef.build("FA", "999",
            d::TableDef.build("Table 1 - Header",
              s::AK1.use(200, r::Mandatory, d::RepeatCount.bounded(1)),
              d::LoopDef.build("AK2", d::RepeatCount.unbounded,
                s::AK2.use(300, r::Optional,  d::RepeatCount.bounded(1)),
                d::LoopDef.build("AK2/IK3", d::RepeatCount.unbounded,
                  s::IK3.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                  s::CTX.use(500, r::Optional,  d::RepeatCount.bounded(10)),
                  d::LoopDef.build("AK2/IK3/IK4", d::RepeatCount.unbounded,
                    s::IK4.use(600, r::Optional,  d::RepeatCount.bounded(1)),
                    s::CTX.use(700, r::Optional,  d::RepeatCount.bounded(10)))),
                s::IK5.use(800, r::Mandatory, d::RepeatCount.bounded(1))),
              s::AK9.use(900, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end

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

          FA999 = d::TransactionSetDef.build("FA", "999",
            "Implementation Acknowledgment",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use(100, r::Mandatory, d::RepeatCount.bounded(1)),
              s::AK1.use(200, r::Mandatory, d::RepeatCount.bounded(1)),

              d::LoopDef.build("2000", d::RepeatCount.unbounded,
                s::AK2.use(300, r::Optional,  d::RepeatCount.bounded(1)),

                d::LoopDef.build("2100", d::RepeatCount.unbounded,
                  s::IK3.use(400, r::Optional,  d::RepeatCount.bounded(1)),
                  s::CTX.use(500, r::Optional,  d::RepeatCount.bounded(10)),

                  d::LoopDef.build("2110", d::RepeatCount.unbounded,
                    s::IK4.use(600, r::Optional,  d::RepeatCount.bounded(1)),
                    s::CTX.use(700, r::Optional,  d::RepeatCount.bounded(10)))),

                s::IK5.use(800, r::Mandatory, d::RepeatCount.bounded(1))),

              s::AK9.use( 900, r::Mandatory, d::RepeatCount.bounded(1)),
              s:: SE.use(1000, r::Mandatory, d::RepeatCount.bounded(1))))

        end
      end
    end
  end
end

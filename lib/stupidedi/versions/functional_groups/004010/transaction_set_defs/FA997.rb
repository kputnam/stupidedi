module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module TransactionSetDefs
          d = Schema
          r = SegmentReqs
          s = SegmentDefs

          FA997 = d::TransactionSetDef.build("FA", "997",
            "Functional Acknowledgment",

            d::TableDef.header("Table 1 - Header",
              s:: ST.use(10, r::Mandatory, d::RepeatCount.bounded(1)),
              s::AK1.use(20, r::Mandatory, d::RepeatCount.bounded(1)),

              s::AK9.use(70, r::Mandatory, d::RepeatCount.bounded(1)),
              s::SE.use(80, r::Mandatory, d::RepeatCount.bounded(1))
            )
          )

        end
      end
    end
  end
end

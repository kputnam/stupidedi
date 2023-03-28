module Stupidedi
  module TransactionSets
    module FortyTen
      module Standards
        b = Builder
        d = Schema
        r = SegmentReqs
        s = SegmentDefs

        LB823 = b.build("LB", "823", "Lockbox",
          d::TableDef.header("1 - Header",
            s::ST.use(10, r::Mandatory, d::RepeatCount.bounded(1)),
            s::N1.use(20, r::Mandatory, d::RepeatCount.bounded(1)),
            s::N1.use(30, r::Mandatory, d::RepeatCount.bounded(1)),
            s::DEP.use(40, r::Mandatory, d::RepeatCount.bounded(1)), # To indicate the lockbox ID, date, time, deposit number and bank account information
            s::AMT.use(50, r::Mandatory, d::RepeatCount.bounded(1)), # Total Amount
            s::QTY.use(60, r::Mandatory, d::RepeatCount.bounded(2)), # Number of Batches AND Number of Checks/Trans

          d::TableDef.detail("2 - Detail",
            d::LoopDef.build("BAT", d::RepeatCount.bounded(100),
              s::BAT.use( 10, r::Mandatory, d::RepeatCount.bounded(1))),
              s::AMT.use( 20, r::Mandatory, d::RepeatCount.bounded(1))), # Total Amount of Batch

            d::LoopDef.build("BPR", d::RepeatCount.bounded(100),
              s::BPR.use( 30, r::Mandatory, d::RepeatCount.bounded(1))), # Beginning segment for Payment Order/Remittance Advice
              s::REF.use( 40, r::Mandatory, d::RepeatCount.bounded(1))),
              s::REF.use( 50, r::Mandatory, d::RepeatCount.bounded(1))), # Required by DMSi just eol
              s::DTM.use( 60, r::Mandatory, d::RepeatCount.bounded(1))), # Date the Remittance was created
              s::N1.use( 70, r::Mandatory, d::RepeatCount.bounded(1))), # Customer Name

            d::LoopDef.build("RMR", d::RepeatCount.bounded(100),
              s::RMR.use( 80, r::Mandatory, d::RepeatCount.bounded(1))), # Accounts receivable item(s)
              s::REF.use( 90, r::Mandatory, d::RepeatCount.bounded(1))), # eol

          d::TableDef.summary("3 - Summary",
            s:: SE.use( 10, r::Mandatory, d::RepeatCount.bounded(1))))

      end
    end
  end
end

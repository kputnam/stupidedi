module Stupidedi
  module Dictionaries
    module FunctionalGroups
      module FiftyTen
        module TransactionSets

          HC837 = TransactionSetDef.build("HC", "837",
            TableDef.build("Table 1 - Header",
              BPR.use(200, Mandatory, RepeatCount.bounded(1)),
              NTE.use(300, Mandatory, RepeatCount.unbounded),
              TRN.use(400, Optional,  RepeatCount.bounded(1)),
              CUR.use(500, Optional,  RepeatCount.bounded(1)),
              REF.use(600, Optional,  RepeatCount.unbounded),
              DTM.use(700, Optional,  RepeatCount.unbounded),
                LoopDef.build("1000", RepeatCount.bounded(200),
                   N1.use( 800, Optional,  RepeatCount.bounded(1)),
                   N2.use( 900, Optional,  RepeatCount.unbounded),
                   N3.use(1000, Optional,  RepeatCount.unbounded),
                   N4.use(1100, Optional,  RepeatCount.bounded(1)),
                  REF.use(1200, Optional,  RepeatCount.unbounded),
                  PER.use(1300, Optional,  RepeatCount.unbounded)),
                  RDM.use(1400, Optional,  RepeatCount.bounded(1)),
                  DTM.use(1500, Optional,  RepeatCount.bounded(1))),
            TableDef.build("Table 2 - Detail",
              LoopDef.build("2000", RepeatCount.unbounded,
                 LX.use(30, Optional,  RepeatCount.bounded(1)),
                TS3.use(50, Optional,  RepeatCount.bounded(1)),
                TS2.use(70, Optional,  RepeatCount.bounded(1)),
                LoopDef.build("2100", RepeatCount.unbounded,
                  CLP.use(100, Mandatory, RepeatCount.bounded(1)),
                  CAS.use(200, Optional,  RepeatCount.bounded(99)),
                  NM1.use(300, Mandatory, RepeatCount.bounded(9)),
                  MIA.use(330, Optional,  RepeatCount.bounded(1)),
                  MOA.use(350, Optional,  RepeatCount.bounded(1)),
                  REF.use(400, Optional,  RepeatCount.bounded(99)),
                  DTM.use(500, Optional,  RepeatCount.bounded(9)),
                  PER.use(600, Optional,  RepeatCount.bounded(3)),
                  AMT.use(620, Optional,  RepeatCount.bounded(3)),
                  QTY.use(640, Optional,  RepeatCount.bounded(20))),
                  LoopDef.build("2110", RepeatCount.bounded(999),
                    SVC.use( 700, Optional,  RepeatCount.bounded(1)),
                    DTM.use( 800, Optional,  RepeatCount.bounded(9)),
                    CAS.use( 900, Optional,  RepeatCount.bounded(99)),
                    REF.use(1000, Optional,  RepeatCount.bounded(99)),
                    AMT.use(1100, Optional,  RepeatCount.bounded(20)),
                    QTY.use(1200, Optional,  RepeatCount.bounded(20)),
                     LQ.use(1300, Optional,  RepeatCount.bounded(99))))),
            TableDef.build("Table 3 - Summary",
              PLB.use(100, Optional,  RepeatCount.unbounded)))
        
        end
      end
    end
  end
end

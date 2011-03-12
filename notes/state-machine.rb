FA999
  Instruction[ ST](pop: 0, drop: 1)
  Instruction[AK1](pop: 0, drop: 2)
  Instruction[AK2](pop: 0, drop: 2, push: LoopState)
    Instruction[AK2](pop: 0, drop: 1)
    Instruction[IK3](pop: 0, drop: 1, push: LoopState)
      Instruction[IK3](pop: 0, drop: 1)
      Instruction[CTX](pop: 0, drop: 1)
      Instruction[IK4](pop: 0, drop: 2, push: LoopState)
        Instruction[IK4](pop: 0, drop: 1)
        Instruction[CTX](pop: 0, drop: 1)
    Instruction[IK5](pop: 0, drop: 3)
  Instruction[AK9](pop: 0, drop: 4)
  Instruction[ SE](pop: 0, drop: 5)


  # initial state: TransmissionState
  1: ISA, nil, 0, 0, InterchangeState

  # after reading ISA: InterchangeState[00501]
  1: ISB, use, 0, 1, nil
  2: ISE, use, 0, 2, nil
  3: TA1, use, 0, 2, nil
  4: GS,  nil, 0, 3, FunctionalGroupState
  5: IEA, use, 0, 5, nil
  6: ISA, nil, 1, 0, InterchangeState

  # after reading TA1: InterchangeState[00501]
  1: TA1, use, 0, 0, nil
  2: GS,  nil, 0, 1, FunctionalGroupState
  3: IEA, use, 0, 3, nil
  4: ISA, use, 1, 0, InterchangeState

  # after reading GS: FunctionalGroupState[005010]
  1: ST,  nil, 0, 0, TransactionSetState
  2: GE,  use, 0, 2, nil
  3: GS,  nil, 1, 0, FunctionalGroupState
  4: IEA, use, 1, 2, nil
  5: ISA, nil, 2, 0, InterchangeState

  # after reading ST: TransactionSetState[005010X222] => TableState[Table 1 - Header]
  1: BHT,    use, 0, 1, nil
  2: NM1*40, use, 0, 1, LoopState[1000A]
  3: NM1*41, use, 0, 1, LoopState[1000B]
  4: HL*20,  use, 1, 3, TableState[Table 2 - Provider]
  5: HL*22,  use, 1, 3, TableState[Table 2 - Subscriber]
  6: HL*23,  use, 1, 3, TableState[Table 2 - Patient]
  7: SE,     use, 1, 7, TableState[Table 3 - Summary]
  8: ST,     nil, 2, 7, TransactionSetState
  9: GE      use, 2, 9, nil
 10: GS,     nil, 3, 0, FunctionalGroupState
 11: IEA,    use, 3, 2, nil
 12: ISA,    nil, 4, 0, InterchangeState

  # after reading HL*22: TableState[Table 2 - Subscriber] => LoopState[2000B]
  1: SBR,     use, 0, 1, nil
  2: PAT,     use, 0, 2, nil
  3: NM1*IL,  use, 0, 2, LoopState[2010BA]
  4: NM1*PR,  use, 0, 2, LoopState[2010BA]
  5: CLM,     use, 0, 4, LoopState[2300]
  6: HL*20,   use, 2, 5, TableState[Table 2 - Provider]
  7: HL*22,   use, 2, 5, TableState[Table 2 - Subscriber]
  8: HL*23,   use, 2, 5, TableState[Table 2 - Patient]
  9: SE,      use, 2, 9, TableState[Table 3 - Summary]
 10: ST,      nil, 3, 9, TransactionSetState
 11: GE,      use, 4, 11, nil
 12: GS,      nil, 5, 1, FunctionalGroupState
 13: IEA,     use, 5, 2, nil
 14: ISA,     nil, 6, 0, InterchangeState

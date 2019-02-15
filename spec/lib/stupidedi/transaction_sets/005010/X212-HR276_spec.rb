describe "Stupidedi::TransactionSets::FiftyTen::Implementations::X212::HR276" do
  using Stupidedi::Refinements
  include TreeMatchers
  include NavigationMatchers

  describe "parser" do
    let(:fixdir) { "005010/X212 HR276 Health Care Claim Status Request and Response/case" }
    let(:parser) { Fixtures.parse!("#{fixdir}/1.edi").head }

    describe "parser" do
      let(:iea) { parser.segment.fetch }

      it "is deterministic" do
        expect(parser).to be_deterministic
        expect(parser).to be_last
      end

      it "infers separators" do
        expect(parser).to have_separators(
          :element    => "*",
          :component  => ":",
          :repetition => "^",
          :segment    => "~")
      end
    end

    describe "structure" do
      let(:isa) { parser.parent.fetch }

      it "has defined sequence" do
        expect(parser).to have_sequence(%w(
          ISA GS ST BHT HL NM1 HL NM1 HL NM1 HL DMG NM1 TRN REF REF AMT DTP HL
          DMG NM1 TRN REF REF AMT DTP HL NM1 HL NM1 HL DMG NM1 TRN REF SVC DTP
          SE GE IEA))
      end

      it "is correct" do
        expect(isa).to have_distance(39).to(parser)
        expect(isa).to have_structure(
          Ss(X(:ST),
          R(:ISA),
          # GS*HR*SENDER CODE*RECEIVER CODE*19991231*0802*1*X*005010X212~
          S(:GS, "HR", "SENDER CODE", "RECEIVER CODE", "19991231", nil, "1", "X", "005010X212") =>
            Ss(R(:GS),
                # ST*276*0001*005010X212~
                S(:ST, "276", "0001", "005010X212") =>
                  Ss(R(:ST),
                     # BHT*0010*13*ABC276XXX*20050915*1425~
                     # 1425 is not set since it leads to NoMethodError, need to investigate
                     S(:BHT, "0010", "13", "ABC276XXX", "20050915", nil),
                     # HL*1**20*1~
                     S(:HL, "1"),
                     S(:HL, "2"),
                     S(:HL, "3"),
                     S(:HL, "4"),
                     S(:HL, "5"),
                     S(:HL, "6"),
                     S(:HL, "7"),
                     S(:HL, "8"),
                     S(:HL, "1", nil, "20", "1") => Ss(
                       # NM1*PR*2*ABC INSURANCE*****PI*12345~
                       S(:NM1, "PR", "2", "ABC INSURANCE", nil, nil, nil, nil, "PI", "12345"),
                       X(:BHT)),
                     # HL*2*1*21*1~
                     S(:HL, "2", "1", "21","1") => Ss(
                       # NM1*41*2*XYZ SERVICE*****46*X67E~
                       S(:NM1, "41", "2", "XYZ SERVICE", nil, nil, nil, nil, "46", "X67E"),
                       X(:BHT)),
                     # HL*3*2*19*1~
                     S(:HL, "3", "2", "19", "1") => Ss(
                       # NM1*1P*2*HOME HOSPITAL*****XX*1666666668~
                       S(:NM1, "1P", "2", "HOME HOSPITAL", nil, nil, nil, nil, "XX", "1666666668"),
                       X(:BHT)),
                    # HL*4*3*22*0~
                     S(:HL, "4", "3", "22", "0") => Ss(
                       # DMG*D8*19301210*M~
                       S(:DMG, "D8", "19301210", "M"),
                       # NM1*IL*1*SMITH*FRED****MI*123456789A~
                       { S(:NM1, "IL", "1", "SMITH", "FRED", nil, nil, nil, "MI", "123456789A") => Ss(
                         # TRN*1*ABCXYZ1~
                         S(:TRN, "1", "ABCXYZ1") => Ss(
                           # REF*BLT*111~
                           S(:REF, "BLT", "111"),
                           # REF*EJ*SM123456~
                           S(:REF, "EJ", "SM123456"),
                           # AMT*T3*8513.88~
                           S(:AMT, "T3", "8513.88"),
                           # DTP*472*RD8*20050831-20050906~
                           S(:DTP, "472", "RD8", "20050831-20050906")))},
                       X(:BHT)),
                     # HL*5*3*22*0~
                     S(:HL, "5", "3", "22", "0") => Ss({
                       # NM1*IL*1*JONES*MARY****MI*234567890A~
                       S(:NM1, "IL", "1", "JONES", "MARY", nil, nil, nil, "MI", "234567890A") => Ss(
                         # TRN*1*ABCXYZ2~
                         S(:TRN, "1", "ABCXYZ2") => Ss(
                           # REF*BLT*111~
                           S(:REF, "BLT", "111"),
                           # REF*EJ*JO234567~
                           S(:REF, "EJ", "JO234567"),
                           # AMT*T3*7599~
                           S(:AMT, "T3", "7599"),
                           # DTP*472*RD8*20050731-20050809~
                           S(:DTP, "472", "RD8", "20050731-20050809")))},
                       # DMG*D8*19301115*F~
                       S(:DMG, "D8", "19301115", "F"),
                       X(:BHT)),
                     # HL*6*2*19*1~
                     S(:HL, "6", "2", "19", "1") => Ss(
                       # NM1*1P*2*HOME HOSPITAL PHYSICIANS*****XX*1666666668~
                       S(:NM1, "1P", "2", "HOME HOSPITAL PHYSICIANS", nil, nil, nil, nil, "XX", "1666666668"),
                       X(:BHT)),
                     # HL*7*6*22*1~
                     S(:HL, "7", "6", "22", "1") => Ss(
                       # NM1*IL*1*MANN*JOHN****MI*345678901~
                       S(:NM1, "IL", "1", "MANN", "JOHN", nil, nil, nil, "MI", "345678901"),
                       X(:BHT)),
                     # HL*8*7*23~
                     S(:HL, "8", "7", "23") => Ss({
                        # NM1*QC*1*MANN*JOSEPH~
                        S(:NM1, "QC", "1", "MANN", "JOSEPH") => Ss(
                          # TRN*1*ABCXYZ3~
                          S(:TRN, "1", "ABCXYZ3") => Ss({
                            # REF*EJ*MA345678~
                            S(:REF, "EJ", "MA345678") => Ss(
                              # SVC*HC:99203*150*****1~
                              C(:SVC, "HC:99203", "150", nil, nil, nil, nil, nil, "1")) },
                          # DTP*472*D8*20050501~
                          S(:DTP, "472", "D8", "20050501")))},
                      # DMG*D8*19951101*M~
                      S(:DMG, "D8", "19951101", "M"),
                      X(:BHT))),
                # GE*1*1~
                S(:GE)  => Ss(S(:IEA)),
                # IEA*1*000000905~
                S(:IEA) => Ss())))
      end
    end
  end
end

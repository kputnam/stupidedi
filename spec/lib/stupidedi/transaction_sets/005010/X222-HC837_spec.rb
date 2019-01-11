using Stupidedi::Refinements

describe "Stupidedi::TransactionSets::Implementations::X222::HC837" do
  include NavigationMatchers

  let(:parser) { Fixtures.parse!("005010/X222-HC837/pass/1.x12").head }

  context "parser" do
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

    it "knows iea position" do
      expect(iea.node.position.line).to eq(53)
      expect(iea.node.position.column).to eq(1)
    end
  end

  context "structure" do
    let(:isa) { parser.parent.fetch }

    it "has defined sequence" do
      expect(parser).to have_sequence(%w(
        ISA GS ST BHT NM1 PER NM1 HL PRV NM1 N3 N4 REF NM1 N3 N4 HL SBR NM1 N3
        N4 DMG NM1 N4 REF HL PAT NM1 N3 N4 DMG CLM REF HI LX SV1 DTP LX SV1 DTP
        LX SV1 DTP LX SV1 DTP SE GE IEA))
    end

    it "is correct" do
      # Should have 49 total segments in the parse tree
      expect(isa).to have_distance(48).to(parser)

      # See matchers/navigation_matchers.rb
      #
      # Ss: list of segment matchers
      #  C: composite element
      #
      #  S: the segment might be reachable, and /is/ reachable
      #  R: the segment might be reachable, but didn't occur
      #  X: the segment would never be reachable
      #
      expect(isa).to have_structure(
        Ss(X(:ST),
           R(:ISA), # No more ISAs
           S(:GS, "HC", nil, nil, nil, nil, 1) =>
             Ss(R(:GS), # No more GSs
                S(:ST) =>
                  Ss(R(:ST), # No more STs
                     X(:PRV),
                     X(:NM1, "85"),
                     X(:NM1, "87"),
                     X(:SBR),
                     X(:NM1, "IL"),
                     X(:NM1, "PR"),
                     S(:BHT) =>
                       Ss(S(:NM1, "41"),
                          S(:NM1, "40"),
                          S(:HL, "1"),
                          S(:HL, "2"),
                          S(:HL, "3"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),
                     # 1000A SUBMITTER NAME
                     S(:NM1, "41") =>
                       Ss(S(:PER),
                          S(:NM1, "40"),
                          S(:HL,  "1"),
                          S(:HL,  "2"),
                          S(:HL,  "3"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),
                     # 1000B RECEIVER NAME
                     S(:NM1, "40") =>
                       Ss(S(:HL, "1"),
                          S(:HL, "2"),
                          S(:HL, "3"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),
                     # 2000A BILLING PROVIDER HIERARCHICAL LEVEL
                     S(:HL, "1") =>
                       Ss(S(:PRV) =>
                            Ss(S(:NM1, "85"),
                               S(:NM1, "87"),
                               S(:HL, "2"),
                               S(:HL, "3"),
                               S(:SE),
                               S(:GE),
                               S(:IEA)),
                          # 2010AA BILLING PROVIDER NAME
                          S(:NM1, "85") =>
                            Ss(S(:NM1, "87") => Ss(),
                               S(:N3)        => Ss(S(:N4),
                                                   S(:REF, "EI"),
                                                   S(:NM1, "87")),
                               S(:N4)        => Ss(S(:REF, "EI"),
                                                   S(:NM1, "87")),
                               S(:REF, "EI") => Ss(S(:NM1, "87")),
                               S(:SE)        => Ss(),
                               S(:GE)        => Ss(),
                               S(:IEA)       => Ss()),
                          # 2010AB PAY-TO ADDRESS NAME
                          S(:NM1, "87") =>
                            Ss(S(:N3)  => Ss(S(:N4),
                                             S(:HL, "2")),
                               S(:N4)  => Ss(S(:HL, "2")),
                               S(:SE)  => Ss(),
                               S(:GE)  => Ss(),
                               S(:IEA) => Ss()),
                          S(:HL, "2") => Ss(),
                          S(:HL, "3") => Ss(),
                          S(:SE)      => Ss(),
                          S(:GE)      => Ss(),
                          S(:IEA)     => Ss()),
                       # 2000B SUBSCRIBER HIERARCHICAL LEVEL
                       S(:HL, "2") =>
                         Ss(S(:SBR) =>
                              Ss(S(:NM1, "IL"),
                                 S(:NM1, "PR"),
                                 S(:HL, "3"),
                                 S(:SE),
                                 S(:GE),
                                 S(:IEA)),
                            # 2010BA SUBSCRIBER NAME
                            S(:NM1, "IL") =>
                              Ss(S(:N3)  => Ss(S(:N4),
                                               S(:DMG),
                                               S(:NM1, "PR"),
                                               S(:HL, "3")),
                                 S(:N4)  => Ss(S(:DMG),
                                               S(:NM1, "PR"),
                                               S(:HL, "3")),
                                 S(:DMG) => Ss(S(:NM1, "PR"),
                                               S(:HL, "3")),
                                 S(:SE)  => Ss(),
                                 S(:GE)  => Ss(),
                                 S(:IEA) => Ss()),
                            # 2010BB PAYER NAME
                            S(:NM1, "PR") =>
                              Ss(S(:N4) => Ss(S(:REF, "G2"),
                                              S(:HL, "3")),
                                 S(:REF, "G2") => Ss(S(:HL, "3")),
                                 S(:SE)        => Ss(),
                                 S(:GE)        => Ss(),
                                 S(:IEA)       => Ss()),
                            S(:HL, "3") => Ss(),
                            S(:SE)      => Ss(),
                            S(:GE)      => Ss(),
                            S(:IEA)     => Ss()),
                       # 2000C PATIENT HIERARCHICAL LEVEL
                       S(:HL, "3") =>
                         Ss(S(:PAT) => Ss(S(:NM1, "QC"),
                                          S(:CLM),
                                          S(:SE),
                                          S(:GE),
                                          S(:IEA)),
                            # 2010CA PATIENT NAME
                            S(:NM1, "QC") =>
                              Ss(S(:N3)  => Ss(S(:N4),
                                               S(:DMG),
                                               S(:CLM)),
                                 S(:N4)  => Ss(S(:DMG),
                                               S(:CLM)),
                                 S(:DMG) => Ss(S(:CLM)),
                                 S(:CLM) => Ss(),
                                 S(:SE)  => Ss(),
                                 S(:GE)  => Ss(),
                                 S(:IEA) => Ss()),
                            # 2300 CLAIM INFORMATION
                            S(:CLM) =>
                              Ss(R(:CLM), # No more CLMs
                                 S(:REF, "D9"),
                                 S(:HI, C("BK", "0340"), C("BF", "V7389")),
                                 # 2400 SERVICE LINE NUMBER
                                 S(:LX, "1") =>
                                   Ss(R(:LX, "1"), # No more LX*1's
                                      S(:LX, "2"),
                                      S(:LX, "3"),
                                      S(:LX, "4"),
                                      S(:SV1, C(nil, "99213")) => Ss(S(:DTP, "472"),
                                                                     S(:LX, "2"),
                                                                     S(:LX, "3"),
                                                                     S(:LX, "4"),
                                                                     S(:SE),
                                                                     S(:GE),
                                                                     S(:IEA)),
                                      S(:DTP, "472") => Ss(S(:LX, "2"),
                                                           S(:LX, "3"),
                                                           S(:LX, "4"),
                                                           S(:SE),
                                                           S(:GE),
                                                           S(:IEA))),
                                 # 2400 SERVICE LINE NUMBER
                                 S(:LX, "2") =>
                                   Ss(R(:LX, "1"),
                                      R(:LX, "2"), # No more LX*2's
                                      S(:LX, "3"),
                                      S(:LX, "4"),
                                      S(:SV1, C(nil, "87070")) => Ss(S(:DTP, "472"),
                                                                     S(:LX, "3"),
                                                                     S(:LX, "4"),
                                                                     S(:SE),
                                                                     S(:GE),
                                                                     S(:IEA)),
                                      S(:DTP, "472") => Ss(S(:LX, "3"),
                                                           S(:LX, "4"),
                                                           S(:SE),
                                                           S(:GE),
                                                           S(:IEA))),
                                 # 2400 SERVICE LINE NUMBER
                                 S(:LX, "3") =>
                                   Ss(R(:LX, "1"), # No more LX*1's
                                      R(:LX, "2"), # No more LX*2's
                                      R(:LX, "3"), # No more LX*3's
                                      S(:LX, "4"),
                                      S(:SV1, C(nil, "99214")) => Ss(S(:DTP, "472"),
                                                                     S(:LX, "4"),
                                                                     S(:SE),
                                                                     S(:GE),
                                                                     S(:IEA)),
                                      S(:DTP, "472") => Ss(S(:LX, "4"),
                                                           S(:SE),
                                                           S(:GE),
                                                           S(:IEA))),
                                 # 2400 SERVICE LINE NUMBER
                                 S(:LX, "4") =>
                                   Ss(R(:LX, "1"),
                                      R(:LX, "2"),
                                      R(:LX, "3"),
                                      R(:LX, "4"),
                                      S(:SV1, C(nil, "86663")) => Ss(S(:DTP, "472"),
                                                                     S(:SE),
                                                                     S(:GE),
                                                                     S(:IEA)),
                                      S(:DTP, "472") => Ss(S(:SE),
                                                           S(:GE),
                                                           S(:IEA))))),
                     S(:SE) => Ss(S(:GE),
                                  S(:IEA))),
                S(:GE)  => Ss(S(:IEA)),
                S(:IEA) => Ss())))
    end
  end
end

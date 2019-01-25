describe "Stupidedi::TransactionSets::FiftyTen::Implementations::X222A1::HC837" do
  using Stupidedi::Refinements
  include NavigationMatchers

  let(:fixdir) { "005010/X222 HC837 Health Care Claim Professional/case" }
  let(:parser) { Fixtures.parse!("#{fixdir}/1.edi").head }

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

    context "with table level permutations" do
      # 837
      #   Table 2A
      #     2000A HL*..*..*20
      #   Table 2B
      #     2000B HL*..*..*22
      #   Table 2C
      #     2000C HL*..*..*23
      let(:dsl) do
        b = Stupidedi::Parser::BuilderDsl.build(Stupidedi::Config.hipaa, false)
        b.ISA("00", nil, "01", "SECRET", "ZZ", "SUBMITTER", "ZZ", "RECEIVER", Time.now.utc, Time.now.utc, nil, "00501", 123456789, "1", "T", nil)
        b. GS("HC", "SENDER", "RECEIVER", Time.now.utc, Time.now.utc, 1, "X", "005010X222")
        b. ST("837", "0001", b.default)
        b.BHT("0019", "00", "46X2A6", Time.now.utc, Time.now.utc, "CH")
        b.NM1("41", "2", "TERRIBLE BILLING", nil, nil, nil, nil, "46", "X82BJJ")
        b.PER("IC", nil, "TE", "5551212")
        b.NM1("40", "2", "TERRIBLE INSURAN", nil, nil, nil, nil, "46", "3057XK")
      end

      it "in HL*..*..20, HL*..*..*22, HL*..*..*23 are handled" do
        ss = [["1", nil, "20", "1"],
              ["2", nil, "20", "1"],
              ["3", "1", "22", "1"],
              ["4", "2", "22", "1"],
              ["5", "3", "23", "0"],
              ["6", "4", "23", "0"]]

        ss.permutation do |p|
          b = dsl.dup.tap{|b_| p.each{|es| b_.send(:HL, *es) }}
          m = b.machine.first.flatmap{|x| x.sequence(:GS, :ST) }

          # expect(m.map{|x| x.count(:HL, nil, nil, "20") }).to be_success(2)
          expect(m.map{|x| x.count(:HL, nil, nil, "22") }).to be_success(2)
          expect(m.map{|x| x.count(:HL, nil, nil, "23") }).to be_success(2)

          expect(m.map{|x| x.count(:HL) }).to be_success(6)

          expect(m.flatmap{|x| x.sequence(:HL) }.
            map{|x| x.count(:HL) }).to be_success(5)

          expect(m.flatmap{|x| x.sequence(:HL, :HL) }.
            map{|x| x.count(:HL) }).to be_success(4)

          expect(m.flatmap{|x| x.sequence(:HL, :HL, :HL) }.
            map{|x| x.count(:HL) }).to be_success(3)

          expect(m.flatmap{|x| x.sequence(:HL, :HL, :HL, :HL) }.
            map{|x| x.count(:HL) }).to be_success(2)

          expect(m.flatmap{|x| x.sequence(:HL, :HL, :HL, :HL, :HL) }.
            map{|x| x.count(:HL) }).to be_success(1)

          expect(m.flatmap{|x| x.sequence(:HL, :HL, :HL, :HL, :HL, :HL) }.
            map{|x| x.count(:HL) }).to be_success(0)
        end if ss.respond_to?(:permutation)
      end
    end


    context "with loop-level permutations" do
      # 835
      #   Table 1
      #     1000A NM1*41
      #     1000B NM1*40
      let(:dsl) do
        b = Stupidedi::Parser::BuilderDsl.build(Stupidedi::Config.hipaa, false)
        b.ISA("00", nil,
              "01", "SECRET",
              "ZZ", "SUBMITTER",
              "ZZ", "RECEIVER",
              Time.now.utc, Time.now.utc, nil,
              "00501", 123456789, "1", "T", nil)
        b. GS("HC", "SENDER", "RECEIVER", Time.now.utc, Time.now.utc, 1, "X", "005010X222")
        b. ST("837", "0001")
        b.BHT("0019", "00", "46X2A6", Time.now.utc, Time.now.utc, "CH")
      end

      specify "in NM1*41, NM1*40 is handled" do
        ss = [["41", "2", "TERRIBLE BILLING", nil, nil, nil, nil, "46", "X82BJJ"],
              ["40", "2", "TERRIBLE INSURAN", nil, nil, nil, nil, "46", "3057XK"]]

        ss.permutation do |p|
          b = dsl.dup
          p.each{|es| b.send(:NM1, *es) }

          m = b.machine.parent
          expect(m.map{|x| x.count(:NM1) }).to be_success(2)

          expect(m.flatmap{|x| x.sequence(:NM1) }.
            map{|x| x.count(:NM1) }).to be_success(1)

          expect(m.flatmap{|x| x.sequence(:NM1, :NM1) }.
            map{|x| x.count(:NM1) }).to be_success(0)
        end if ss.respond_to?(:permutation)
      end
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

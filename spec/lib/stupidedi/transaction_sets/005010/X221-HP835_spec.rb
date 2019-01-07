using Stupidedi::Refinements

describe "X221-HP835" do
  include NavigationMatchers

  let(:parser) { Fixtures.file("005010/X221-HP835/1-good.txt") }

  context "parser" do
    let(:iea) { parser.segment.fetch }

    it "is deterministic" do
      expect(parser).to be_deterministic
      expect(parser).to be_last
    end

    it "knows iea position" do
      expect(iea.node.position.line).to eq(40)
      expect(iea.node.position.column).to eq(1)
    end

    it "infers separators" do
      expect(parser).to have_separators(
        :element    => "+",
        :component  => ">",
        :repetition => "~",
        :segment    => "\r")
    end
  end

  context "structure" do
    let(:isa) { parser.parent.fetch }

    it "has defined sequence" do
      expect(parser).to have_sequence(%w(
        ISA GS ST BPR TRN DTM N1 N3 N4 REF REF N1 REF LX TS3 TS2 CLP CAS NM1 MIA
        DTM DTM AMT QTY LX TS3 CLP CAS NM1 MOA DTM AMT PLB SE GE IEA))
    end

    it "is correct" do
      expect(isa).to have_distance(35).to(parser)
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
           S(:GS, "HP", nil, nil, "19991231", nil, 1) =>
             Ss(R(:GS), # No more GSs
                S(:ST) =>
                  Ss(R(:ST), # No more STs
                     S(:BPR, nil, 150000) =>
                       Ss(S(:TRN),
                          S(:DTM),
                          S(:N1, "PR"),
                          S(:N1, "PE"),
                          S(:LX, "110212"),
                          S(:LX, "130212"),
                          S(:PLB),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),
                     S(:TRN, "1", "12345") =>
                       Ss(X(:BPR)),

                     S(:DTM, "405", Date.civil(2002, 9, 13)) =>
                       Ss(X(:TRN)),

                     # 1000A PAYER IDENTIFICATION
                     S(:N1, "PR", "INSURANCE COMPANY OF TIMBUCKTU") =>
                       Ss(S(:N3, "1 MAIN STREET"),
                          S(:N4),
                          S(:REF, "2U", "999"),
                          S(:REF, "NF", "12345"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),

                     # 1000B PAYEE IDENTIFICATION
                     S(:N1, "PE", nil, "XX", "1232343560") =>
                       Ss(S(:REF, "TJ"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),

                     # 2000 HEADER NUMBER
                     S(:LX, "110212") =>
                       Ss(S(:LX, "130212"),
                          S(:TS3),
                          S(:TS2),
                          S(:CLP) =>
                            Ss(S(:CAS, "CO", 45, "73348.57"),
                               S(:NM1, "QC", nil, "JONES"),
                               S(:MIA, 0, nil, nil, "138018.4".to_d),
                               S(:DTM, "232", "20020816"),
                               S(:DTM, "233", "20020824"),
                               S(:AMT, "AU", 150000),
                               S(:QTY, "CA", 8))),

                     # 2000 HEADER NUMBER
                     S(:LX, "130212") =>
                       Ss(R(:LX, "110212"),
                          S(:TS3, "6543210909", "13", "1996/12/31", 1, 15000),
                          S(:CLP, "777777") =>
                            Ss(S(:CAS, "CO", "45", "3019.67"),
                               S(:NM1, "QC"),
                               S(:MOA, nil, nil, "MA02"),
                               S(:DTM, "232", "2002-05-12"),
                               S(:AMT, "AU", 17000))),

                     S(:PLB, "6543210903") =>
                       Ss(S(:SE, 32, 1234),
                          S(:GE, 1, 1),
                          S(:IEA, 1, 905)),
                     S(:PLB, nil, "20021231") =>
                       Ss(S(:SE, "32", "1234"),
                          S(:GE, "1", "1"),
                          S(:IEA, "1", "905")),
                     S(:PLB, nil, nil, C("CV", "CP")) => Ss(),
                     S(:PLB, nil, nil, nil, "-1.27")  => Ss(),

                     S(:SE) => Ss(S(:GE),
                                  S(:IEA))),
                S(:GE)  => Ss(S(:IEA)),
                S(:IEA) => Ss())))
    end

    context "with issues in Table 3 (Summary)" do
      context "with missing PLB" do
        let(:parser) { Fixtures.file("005010/X221-HP835/2-good.txt") }

        it "is handled" do
          expect(parser).to be_deterministic

          parser.parent.tap do |isa|
            expect(isa).to have_structure(
              Ss(X(:SE),
                 X(:PLB),
                 S(:GS, "HP", nil, nil, "19991231", nil, 1) =>
                   Ss(X(:SE),
                      X(:PLB),
                      S(:ST) =>
                        Ss(R(:PLB),
                           S(:LX) =>
                             Ss(S(:SE),
                                R(:PLB)),
                           S(:SE) =>
                             Ss(X(:PLB),
                                X(:SE))))))
          end
        end
      end

      context "with single PLB" do
        let(:parser) { Fixtures.file("005010/X221-HP835/1-good.txt") }

        it "is handled" do
          expect(parser).to be_deterministic

          parser.parent.tap do |isa|
            expect(isa).to have_structure(
              Ss(X(:SE),
                 X(:PLB),
                 S(:GS, "HP", nil, nil, "19991231", nil, 1) =>
                   Ss(X(:SE),
                      X(:PLB),
                      S(:ST) =>
                        Ss(S(:LX) =>
                             Ss(S(:SE),
                                S(:PLB)),
                           S(:SE) =>
                             Ss(X(:PLB),
                                X(:SE)),
                           S(:PLB) =>
                             Ss(R(:PLB), # only one PLB
                                S(:SE))))))
          end
        end
      end

      context "with multiple PLBs" do
        let(:parser) { Fixtures.file("005010/X221-HP835/3a-good.txt") }

        it "is handled" do
          expect(parser).to be_deterministic

          parser.parent.tap do |isa|
            expect(isa).to have_structure(
              Ss(X(:SE),
                 X(:PLB),
                 S(:GS, "HP", nil, nil, "19991231", nil, 1) =>
                   Ss(X(:SE),
                      X(:PLB),
                      S(:ST) =>
                        Ss(S(:LX) =>
                             Ss(S(:SE),
                                S(:PLB),
                                S(:PLB, "9876543210"),
                                S(:PLB, "0123456789")),
                           S(:SE) =>
                             Ss(X(:PLB),
                                X(:SE)),
                           S(:PLB) =>
                             Ss(S(:PLB),
                                S(:PLB, "0123456789"),
                                R(:PLB, "9876543210"),
                                S(:SE)),
                           S(:PLB, "0123456789") =>
                             Ss(R(:PLB, "0123456789"),
                                R(:PLB, "9876543210"),
                                S(:SE)),
                           S(:PLB, "9876543210") =>
                             Ss(R(:PLB, "9876543210"),
                                S(:PLB, "0123456789"),
                                S(:SE))))))
          end
        end
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
          b. GS("HP", "SENDER", "RECEIVER", Time.now.utc, Time.now.utc, 1, "X", "005010X222")
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
            b = dsl.dup
            p.each{|es| b.send(:HL, *es) }

            m = b.machine.first.flatmap{|x| x.sequence(:GS, :ST) }

            expect(m.map{|x| x.count(:HL, nil, nil, "20") }).to be_success(2)
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
        # 837
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
          b. GS("HP", "SENDER", "RECEIVER", Time.now.utc, Time.now.utc, 1, "X", "005010X222")
          b. ST("837", "0001", b.default)
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

      context "with segment-level permutations" do
        # 835
        #   Table 1
        #     1000A N1*PR
        #       PER*CX
        #       PER*BL
        #       PER*IC
        let(:dsl) do
          c = Stupidedi::Config.hipaa
          b = Stupidedi::Parser::BuilderDsl.build(c)
          b.ISA("00", nil, "01", "SECRET", "ZZ", "SUBMITTER", "ZZ", "RECEIVER", Time.now.utc, Time.now.utc, nil, "00501", 123456789, "1", "T", nil)
          b. GS("HP", "SENDER", "RECEIVER", Time.now.utc, Time.now.utc, 1, "X", "005010X221")
          b. ST("835", "0001")
          b.BPR("C", 150000, "C", "ACH", "CTX", "01", "999999992", "DA", "123456", "1512345678", nil, "01", "999988880", "DA", "98765", "20020913")
          b.TRN("1", "12345", "1512345678")
          b.DTM("405", Time.now.utc)
          b. N1("PR", "INSURANCE COMPANY OF TIMBUCKTU")
          b. N3("1 MAIN STREET")
          b. N4("TIMBUCKTU", "AK", "99501")
          b.REF("2U", "999")
          b.REF("NF", "12345")
        end

        specify "in PER*IC, PER*BL, PER*CX is handled" do
          ss = [["IC", nil, "UR", "WEBSITE.COM"],
                ["BL", "COMPUTER PAT"],
                ["BL", "COMPUTER SAM"],
                ["CX", "BUSINESS KIM"]]

          ss.permutation do |p|
            b = dsl.dup
            p.each{|es| b.send(:PER, *es) }

            m = b.machine.parent
            expect(m.map{|x| x.count(:PER) }).to be_success(4)

            expect(m.flatmap{|x| x.sequence(:PER) }.
              map{|x| x.count(:PER) }).to be_success(3)

            expect(m.flatmap{|x| x.sequence(:PER, :PER) }.
              map{|x| x.count(:PER) }).to be_success(2)

            expect(m.flatmap{|x| x.sequence(:PER, :PER, :PER) }.
              map{|x| x.count(:PER) }).to be_success(1)

            expect(m.flatmap{|x| x.sequence(:PER, :PER, :PER, :PER) }.
              map{|x| x.count(:PER) }).to be_success(0)
          end if ss.respond_to?(:permutation)
        end
      end
    end
  end
end

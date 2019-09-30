describe "Stupidedi::TransactionSets::FiftyTen::Implementations::X221A1::HP835" do
  using Stupidedi::Refinements
  include TreeMatchers
  include NavigationMatchers

  let(:fixdir) { "005010/X221 HP835 Health Care Claim Payment Advice/case" }
  let(:parser) { Fixtures.parse!("#{fixdir}/1.edi").head }

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
        ISA GS ST BPR TRN DTM N1 N3 N4 REF REF N1 REF LX TS3 TS2 CLP CAS NM1
        MIA DTM DTM AMT QTY LX TS3 CLP CAS NM1 MOA DTM AMT PLB SE GE IEA))
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
                          X(:N1, "XX"),
                          S(:LX, "110212"),
                          S(:LX, "130212"),
                          X(:TS3),
                          X(:TS2),
                          X(:CLP),
                          S(:PLB),
                          S(:PLB, "6543210903"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),
                     S(:TRN, "1", "12345") =>
                       Ss(R(:ST),
                          X(:TRN),
                          X(:BPR),
                          S(:LX, "110212"),
                          S(:LX, "130212"),
                          X(:TS3),
                          X(:TS2),
                          X(:CLP),
                          S(:PLB, "6543210903"),
                          S(:SE)),

                     S(:DTM, "405", Date.civil(2002, 9, 13)) =>
                       Ss(X(:TRN),
                          X(:DTM),
                          S(:N1),
                          X(:N2),
                          X(:REF)),

                     # 1000A PAYER IDENTIFICATION
                     S(:N1, "PR", "INSURANCE COMPANY OF TIMBUCKTU") =>
                       Ss(S(:N3, "1 MAIN STREET"),
                          S(:N4),
                          S(:REF, "2U", "999"),
                          S(:REF, "NF", "12345"),
                          S(:LX, "110212"),
                          S(:LX, "130212"),
                          R(:LX, "000000"),
                          X(:TS3),
                          X(:TS2),
                          X(:CLP),
                          S(:PLB, "6543210903"),
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
                          S(:TS3, "6543210909", "13", "19961231", 1, 15000),
                          S(:CLP, "777777") =>
                            Ss(S(:CAS, "CO", "45", "3019.67"),
                               S(:NM1, "QC"),
                               S(:MOA, nil, nil, "MA02"),
                               S(:DTM, "232", "2002-05-12"),
                               S(:AMT, "AU", 17000))),

                     S(:PLB, "6543210903") =>
                       Ss(R(:PLB),
                          S(:SE, 32, 1234),
                          S(:GE, 1, 1),
                          S(:IEA, 1, 905)),
                     S(:PLB, nil, "20021231") =>
                       Ss(R(:PLB),
                          S(:SE, "32", "1234"),
                          S(:GE, "1", "1"),
                          S(:IEA, "1", "905")),
                     S(:PLB, nil, nil, C("CV", "CP")) => Ss(R(:PLB), S(:SE), X(:LX), X(:BPR)),
                     S(:PLB, nil, nil, nil, "-1.27")  => Ss(R(:PLB), S(:SE), X(:LX), X(:N1)),

                     S(:SE) => Ss(S(:GE),
                                  S(:IEA))),
                S(:GE)  => Ss(S(:IEA)),
                S(:IEA) => Ss())))
    end

    context "with issues in Table 3 (Summary)" do
      context "with missing PLB" do
        let(:parser) { Fixtures.parse!("#{fixdir}/2.edi", encoding: "ISO-8859-1").head }

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
        let(:parser) { Fixtures.parse!("#{fixdir}/1.edi").head }

        it "is handled" do
          expect(parser).to be_deterministic

          parser.parent.tap do |isa|
            expect(isa).to have_structure(
              Ss(X(:SE),
                 X(:PLB),
                 S(:GS, "HP", nil, nil, "19991231", nil, 1) =>
                   Ss(X(:SE),
                      X(:LX),
                      X(:PLB),
                      S(:ST) =>
                        Ss(S(:LX) =>
                             Ss(S(:SE),
                                S(:PLB)),
                           S(:SE) =>
                             Ss(R(:ST),
                                X(:LX),
                                X(:PLB),
                                X(:SE)),
                           S(:PLB) =>
                             Ss(R(:ST),
                                X(:LX),
                                R(:PLB), # only one PLB
                                S(:SE))))))
          end
        end
      end

      context "with multiple PLBs" do
        let(:parser) { Fixtures.parse!("#{fixdir}/3a.edi").head }

        it "is handled" do
          expect(parser).to be_deterministic

          parser.parent.tap do |isa|
            expect(isa).to have_structure(
              Ss(X(:SE),
                 X(:PLB),
                 S(:GS, "HP", nil, nil, "19991231", nil, 1) =>
                   Ss(X(:SE),
                      X(:LX),
                      X(:PLB),
                      S(:ST) =>
                        Ss(R(:ST),
                           R(:GS),
                           R(:ISA),
                           S(:LX) =>
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

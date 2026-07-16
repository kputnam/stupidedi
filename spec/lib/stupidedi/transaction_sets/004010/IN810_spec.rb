describe "Stupidedi::TransactionSets::FortyTen::Implementations::IN810" do
  using Stupidedi::Refinements
  include TreeMatchers
  include NavigationMatchers

  describe "parser" do
    let(:fixdir) { "004010/IN810/pass" }
    let(:parser) { Fixtures.parse!("#{fixdir}/1.edi").head }

    describe "parser" do
      let(:iea) { parser.segment.fetch }

      it "is deterministic" do
        expect(parser).to be_deterministic
        expect(parser).to be_last
      end

      it "infers separators" do
        expect(parser).to have_separators(
          :element    => "|",
          :component  => ">",
          :repetition => nil,
          :segment    => "~")
      end
    end

    describe "structure" do
      let(:isa) { parser.parent.fetch }

      it "has defined sequence" do
        expect(parser).to have_sequence(%w(ISA GS ST BIG N1 N3 N4 ITD IT1 PID IT1 PID TDS CTT SE GE IEA))
      end

      it "is correct" do
        expect(isa).to have_distance(16).to(parser)
        expect(isa).to have_structure(
          Ss(X(:ST),
            R(:ISA),
            # GS|IN|111111|2222222|20211118|0752|5639689|X|004010~
            S(:GS, "IN", "111111", "2222222", "20211118", "0752", "5639689", "X", "004010") =>
               Ss(R(:GS),
                  # ST|810|5639689~
                  S(:ST, "810", "5639689") =>
                    Ss(R(:ST),
                       # BIG|20211118|00237058|20211102|0691-0014403~
                       S(:BIG, "20211118", "00237058", "20211102", "0691-0014403"),
                       # N1|ST|Store Shipping Address|ZZ|1091581~
                       S(:N1, "ST", "Store Shipping Address", "ZZ", "1091581") => Ss(
                         # N3|123 address_1|address_2~
                         S(:N3, "123 address_1", "address_2") => Ss(
                           # N4|SAVANNAH|GA|314014245~
                           S(:N4, "SAVANNAH", "GA", "314014245") => Ss())),
                       # ITD||3|||||30~
                       S(:ITD, "", "3", "", "", "", "", "30") => Ss(),
                       # IT1||4||70||||EN|9781501331978|GC|01~
                       S(:IT1, "", "", "", "70", "", "", "", "EN", "9781501331978", "GC", "01") => Ss(
                         # PID|F||||Retail Buying From Basics to Fashion~
                         S(:PID, "F", "", "", "", "Retail Buying From Basics to Fashion") => Ss()),
                       # IT1||1||5.66||||EN|9780316154680|GC|02~
                       S(:IT1, "", "1", "", "5.66", "", "", "", "EN", "9780316154680", "GC", "02") => Ss(
                         # PID|F||||When You Are Engulfed in Flames~
                         S(:PID, "F", "", "", "", "When You Are Engulfed in Flames") => Ss()),
                       # TDS|28566~
                       S(:TDS, "28566") => Ss(
                         # CTT|2|5~
                         S(:CTT, "2", "5") => Ss(
                           # SE|13|5639689~
                           S(:SE, "13", "5639689") => Ss()))),
                  # GE|1|5639689~
                  S(:GE, "1", "5639689") => Ss(S(:IEA)),
                  # IEA|1|005639689~
                  S(:IEA, "1", "005639689") => Ss())))
      end
    end
  end
end

require "spec_helper"
using Stupidedi::Refinements

describe "X091A1-HP835" do
  include NavigationMatchers
  let(:parser) { Fixtures.file("X091A1-HP835/1-good.txt") }

  context 'parser' do
    let(:iea) { parser.segment.fetch }

    it 'is deterministic' do
      expect(parser).to be_deterministic
      expect(parser).to be_last
    end

    it 'infers separators' do
      expect(parser).to have_separators(
        :element => "|",
        :component => "^",
        :repetition => nil,
        :segment => "~"
      )
    end

    it 'knows iea position' do
      expect(iea.node.position.line).to eq(1)
      expect(iea.node.position.column).to eq(606)
    end
  end

  context 'structure' do
    let(:isa) { parser.parent.fetch }

    it 'has defined sequence' do
      expect(parser).to have_sequence(%w(ISA GS ST BPR TRN REF N1 N3 N4 REF PER N1
        REF LX CLP CAS NM1 PLB SE GE IEA))
    end

    it 'is correct' do
      expect(isa).to have_distance(20).to(parser)
      expect(isa).to have_structure(
        Ss(X(:ST),
          R(:ISA), # No more ISAs
          S(:GS, "HP", "MADE UP CLEARING HOUSE", "611358935", "20130508", nil, "3063") =>
          Ss(R(:GS), # No more GSs
                S(:ST) =>
                  Ss(R(:ST), # No more STs
                     S(:BPR, nil, nil) =>
                       Ss(S(:TRN),
                          S(:N1, "PR"),
                          S(:N1, "PE"),
                          S(:LX, "1"),
                          S(:PLB),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),
                     S(:TRN, "1", "74122910359") =>
                       Ss(X(:BPR)),

                     # 1000A PAYER IDENTIFICATION
                     S(:N1, "PR", "MADE UP HEALTH CENTER") =>
                       Ss(S(:N3, "123 FAKE ST."),
                          S(:N4),
                          S(:REF, "2U", "80214"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),

                     # 1000B PAYEE IDENTIFICATION
                     S(:N1, "PE", nil, "XX", "1386672277") =>
                       Ss(S(:REF, "TJ"),
                          S(:SE),
                          S(:GE),
                          S(:IEA)),

                     # 2000 HEADER NUMBER
                     S(:LX, "1") =>
                       Ss(
                        S(:CLP) =>
                          Ss(S(:CAS, "PI", 23, "157.39"),
                               S(:NM1, "QC", nil, "DOE"))),

                     S(:PLB, "341491692") =>
                       Ss(S(:SE, 17, '0001'),
                          S(:GE, 1, 3063),
                          S(:IEA, 1, 3063)),

                     S(:SE) => Ss(S(:GE),
                                  S(:IEA))),
                S(:GE)  => Ss(S(:IEA)),
                S(:IEA) => Ss())))
    end
  end
end

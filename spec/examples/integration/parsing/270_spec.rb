require "spec_helper"

describe "Parsing" do
  include NavigationMatchers

  context "X279-HS270" do
    let(:parser) { Fixtures.file("X279-HS270/1-good.txt") }

    it "parses 1-good.txt" do
      expect(parser).to be_deterministic
      expect(parser).to be_last

      parser.segment.tap do |iea|
        expect(iea.node.position.line).to eq(23)
        expect(iea.node.position.column).to eq(1)
      end

      expect(parser).to have_sequence(%w(ISA GS ST BHT HL NM1 HL NM1 HL TRN NM1 DMG DTP
        EQ SE GE IEA))

      expect(parser).to have_separators(:element => "*", :component => ":",
                                    :repetition => "^", :segment => "~")

      parser.parent.tap do |isa|
        # Should have 16 total segments in the parse tree
        expect(isa).to have_distance(16).to(parser)

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
            R(:ISA),
            S(:GS, "HS", nil, nil, nil, nil, 1) =>
              Ss(R(:GS),
                 S(:ST) =>
                   Ss(R(:ST),
                   X(:PRV)
          ))))
      end
    end
  end
end

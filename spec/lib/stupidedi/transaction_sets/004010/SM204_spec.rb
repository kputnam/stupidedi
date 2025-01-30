describe "Stupidedi::TransactionSets::FortyTen::Implementations::SM204" do
  using Stupidedi::Refinements
  include TreeMatchers
  include NavigationMatchers

  describe "parser" do
    let(:fixdir) { "004010/SM204/case" }
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
          :component  => "|",
          :repetition => nil,
          :segment    => "~")
      end
    end

    describe "structure" do
      let(:isa) { parser.parent.fetch }

      it "has defined sequence" do
        expect(parser).to have_sequence(%w(ISA GS ST B2 B2A L11 L11 L11 L11 L11 L11 G62 NTE NTE N7 S5 G62 PLD NTE NTE N1 N3 N4 G61 OID L5 AT8 G61 L11 L11 L11 OID L5 AT8 G61 L11 L11 L11 S5 G62 PLD NTE NTE N1 N3 N4 G61 OID L5 AT8 G61 L11 L11 L11 OID L5 AT8 G61 L11 L11 L11 L3 SE GE IEA))
      end
    end
      
    describe "L3-05 charge" do
      it "is the correct 2-decimal number" do
        parser.first
        .flatmap{|m| m.find(:GS) }
        .flatmap{|m| m.find(:ST) }
        .flatmap{|m| m.find(:L3) }
        .tap do |m|
          el(m, 5) do |value|
            expect(value.to_f).to eq(2152.67)
            expect(value.to_f).not_to eq(215267)
          end
        end
      end

      def el(m, *ns, &block)
        if Stupidedi::Either === m
          m.tap{|m| el(m, *ns, &block) }
        else
          yield(*ns.map{|n| m.elementn(n).map(&:value).fetch })
        end
      end
    end
  end
end

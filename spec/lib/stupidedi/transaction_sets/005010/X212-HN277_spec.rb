describe "Stupidedit::TransactionSets::FiftyTen::Implementations::X212::HN277" do
  using Stupidedi::Refinements
  include TreeMatchers
  include NavigationMatchers

  describe "use with a basic document" do
    let(:fixdir) { "005010/X212 HR277 Heatlh Care Information Status Notification" }
    let(:parser) { Fixtures.parse!("#{fixdir}/pass/1.era").head }

    describe "parser" do
      subject { parser }

      it { is_expected.to be_deterministic }
      it { is_expected.to be_last }
      it do
        is_expected.to have_separators(
          element:    "*",
          component:  ":",
          repetition: "^",
          segment:    "~"
        )
      end
    end

    describe "structure" do
      subject { parser }
      it do
        is_expected.to have_sequence(%w(
          ISA GS ST BHT HL NM1 HL NM1
          HL NM1 HL NM1 TRN STC REF REF DTP SE GE IEA
        ))
      end
    end
  end
end


describe Stupidedi::TransactionSets::Builder::Dsl do

  context 'with the most basic build' do
    SegmentReqs = Stupidedi::TransactionSets::FiftyTen::Implementations::SegmentReqs
    let(:definition) do
      e  = Stupidedi::TransactionSets::FiftyTen::Implementations::ElementReqs
      st = Stupidedi::TransactionSets::FiftyTen::SegmentDefs::ST
      described_class.build("HH", "100", "Test Fake Document") do
        table_header("1 - Header") do
          segment(100, st, "Transaction Set Header", SegmentReqs::Required, repeat_bounded(1)) do
            element(e::Required, "Transaction Set Identifier Code", values("100"))
            element(e::Required, "Transaction Set Control Number")
            element(e::Required, "Version, Release, or Industry Number", values("1000"))
          end
        end
      end
    end

    describe 'the definition as a whole' do

      subject { definition }

      it 'raises no error on initialization' do
        expect { subject }.to_not raise_error
      end

      it { is_expected.to be_definition }
    end

    describe 'the first table' do
      subject { definition.children.first }
      it { is_expected.to be_table }
      it { is_expected.to be_definition }

      describe 'the first segment in the first table' do
        subject { definition.children.first.children.first }
        it { is_expected.to_not be_repeatable }
        it { is_expected.to be_definition }
        it { is_expected.to be_segment }
        it do
          is_expected.to(
            have_attributes(
              repeat_count: 1,
              requirement: SegmentReqs::Required,
              position: 100,
              name: "Transaction Set Header",
              descriptor: "segment ST Transaction Set Header",
              id: :ST
            )
          )
        end
      end
    end
  end
end

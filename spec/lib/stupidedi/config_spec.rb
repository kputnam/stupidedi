describe Stupidedi::Config do
  include ConfigMatchers

  describe "#customize"

  describe ".default" do
    let(:subject) { Stupidedi::Config.default }
    it { is_expected.to have_valid_interchanges      }
    it { is_expected.to have_valid_functional_groups }
    it { is_expected.to have_valid_transaction_sets  }

    describe "extending another config"
  end

  describe ".hipaa" do
    let(:subject) { Stupidedi::Config.hipaa }
    it { is_expected.to have_valid_interchanges      }
    it { is_expected.to have_valid_functional_groups }
    it { is_expected.to have_valid_transaction_sets  }

    describe "extending another config"
  end

  describe ".contrib" do
    let(:subject) { Stupidedi::Config.contrib }
    it { is_expected.to have_valid_interchanges      }
    it { is_expected.to have_valid_functional_groups }
    it { is_expected.to have_valid_transaction_sets  }

    describe "extending another config"
  end

  describe "#pretty_print" do
    it "doesn't throw an exception" do
      expect(Stupidedi::Config.hipaa.pretty_inspect).to be_a(String)
    end
  end

  todo "combining configs"
end

describe Stupidedi::Reader::Failure do
  include QuickCheck::Macro

  def mkfailure(reason, remainder)
    Stupidedi::Reader::Result.failure(reason, remainder, false)
  end

  describe "#reason" do
    property "is the value given to the constructor" do
      string
    end.check do |s|
      expect(mkfailure(s, "remainder").reason).to be == s
    end
  end

  describe "#remainder" do
    property "is the value given to the constructor" do
      string
    end.check do |s|
      expect(mkfailure("reason", s).remainder).to be == s
    end
  end

  # Note: `method` is dynamically scoped (bound by the caller's environment)
  shared_examples_for "wrapped input delegator method" do
    context "when remainder is wrapped" do
      let(:input) { double("input", :offset => 400, :line => 90, :column => 10) }

      it "returns input.method" do
        expect(mkfailure("reason", input).__send__(method)).to be == input.__send__(method)
      end
    end

    context "when remainder is not wrapped" do
      it "should return nil" do
        expect(mkfailure("reason", "remainder").__send__(method)).to be_nil
      end
    end

    context "when remainder is nil" do
      it "should return nil" do
        expect(mkfailure("reason", nil).__send__(method)).to be_nil
      end
    end
  end

  describe "#offset" do
    it_should_behave_like "wrapped input delegator method" do
      let(:method) { :offset }
    end
  end

  describe "#line" do
    it_should_behave_like "wrapped input delegator method" do
      let(:method) { :line }
    end
  end

  describe "#column" do
    it_should_behave_like "wrapped input delegator method" do
      let(:method) { :column }
    end
  end
end

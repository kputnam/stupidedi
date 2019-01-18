describe Stupidedi::Reader::Success do
  include QuickCheck::Macro

  def mksuccess(value, remainder)
    Stupidedi::Reader::Result.success(value, remainder)
  end

  describe "#value" do
    it "returns the argument given to the constructor" do
      mksuccess("a", "b").tap{|a, b| expect(a).to be == "a" }
    end
  end

  describe "#remainder" do
    it "returns the argument given to the constructor" do
      expect(mksuccess("a", "b").remainder).to be == "b"
      mksuccess("a", "b").tap{|a, b| expect(b).to be == "b" }
    end
  end

  describe "#map" do
    it "returns another result" do
      expect(mksuccess("a", "b").map { }).to be_a(Stupidedi::Reader::Success)
    end

    it "yields the value"
    it "changes the value"
    it "preserves the remainder"
  end
end

require "spec_helper"

describe Stupidedi::Reader::Success do
  include QuickCheck::Macro

  def mksuccess(value, remainder)
    Stupidedi::Reader::Result.success(value, remainder)
  end

  describe "#value" do
    it "returns the argument given to the constructor" do
      mksuccess("a", "b").tap{|a, b| a.should == "a" }
    end
  end

  describe "#remainder" do
    it "returns the argument given to the constructor" do
      mksuccess("a", "b").remainder.should == "b"
      mksuccess("a", "b").tap{|a, b| b.should == "b" }
    end
  end

  describe "#map" do
    it "returns another result" do
      mksuccess("a", "b").map { }.
        should be_a(Stupidedi::Reader::Success)
    end

    it "yields the value"
    it "changes the value"
    it "preserves the remainder"
  end

end

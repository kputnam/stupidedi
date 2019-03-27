using Stupidedi::Refinements

describe Object do
  describe "#blank?" do
    it "is false" do
      expect(Object.new).not_to be_blank
    end
  end
end

describe String do
  describe "#blank?" do
    context "if string contains non-whitespace characters" do
      specify "then is string.blank? is false" do
        expect("abc").to_not be_blank
        expect("  x").to_not be_blank
        expect(" x ").to_not be_blank
        expect("x  ").to_not be_blank
      end
    end

    context "if string is #empty?" do
      specify "then string.blank? is true" do
        expect("").to be_blank
      end
    end

    context "if string contains only whitespace characters" do
      specify "then string.blank? is true" do
        expect("  ").to be_blank
        expect("\t").to be_blank
        expect("\n").to be_blank
        expect("\r").to be_blank
        expect("\f").to be_blank
      end
    end
  end
end

describe Enumerable do
  describe "#blank?" do
    context "if enum.empty?" do
      specify "then enum.blank? is true" do
        expect([]).to be_blank
      end
    end

    context "if not enum.empty?" do
      specify "then enum.blank? is false" do
        expect([0]).to_not be_blank
      end
    end
  end
end

describe NilClass do
  describe "#blank?" do
    it "is true" do
      expect(nil).to be_blank
    end
  end
end

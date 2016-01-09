require "spec_helper"
using Stupidedi::Refinements

describe Object do
  describe "#blank?" do
    it "is false" do
      Object.new.blank?.should_not be
    end
  end
end

describe String do
  describe "#blank?" do
    context "if string contains non-whitespace characters" do
      specify "then is string.blank? is false" do
        "abc".blank?.should_not be
        "  x".blank?.should_not be
        " x ".blank?.should_not be
        "x  ".blank?.should_not be
      end
    end

    context "if string is #empty?" do
      specify "then string.blank? is true" do
        "".blank?.should be
      end
    end

    context "if string contains only whitespace characters" do
      specify "then string.blank? is true" do
        "  ".blank?.should be
        "\t".blank?.should be
        "\n".blank?.should be
        "\r".blank?.should be
        "\f".blank?.should be
      end
    end
  end
end

describe Enumerable do
  describe "#blank?" do
    context "if enum.empty?" do
      specify "then enum.blank? is true" do
        [].blank?.should be
      end
    end

    context "if not enum.empty?" do
      specify "then enum.blank? is false" do
        [0].blank?.should_not be
      end
    end
  end
end

describe NilClass do
  describe "#blank?" do
    it "is true" do
      nil.blank?.should be
    end
  end
end

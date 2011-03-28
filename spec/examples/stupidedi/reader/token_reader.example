require "spec_helper"


describe Stupidedi::Reader::TokenReader do
  include QuickCheck::SerializedEdi::Macro

  describe "#input"
  describe "#separators"
  describe "#segment_dict"

  describe "#stream?" do
    it "returns false"
  end

  describe "#empty?" do
    context "with no input available"
    context "with some input available"
  end

  describe "#consume_prefix(s)" do
    context "when s is empty"
    context "when s is the entire input"
    context "when s is a prefix of the input"
    context "when s is not a prefix of the input"
  end

  describe "#consume(s)" do
    context "when s is empty"
    context "when s is the entire input"
    context "when s is a prefix of the input"
    context "when s is a suffix of the input"
    context "when s does not occur in the input"
    context "when s occurs in the middle of the input"
  end

  describe "#read_segment" do
    context "when the input is empty"
    context "when the input does not start with a valid segment identifier"
    context "when the input does not have a segment terminator"

    context "when the input starts with an iea segment" do
      it "the remainder should be a StreamReader"
    end

    context "when the input contains no elements"
    context "when the input contains one element"
    context "when the input contains many elements"
    context "when the input contains too many elements"

    context "when the input has a non-repeatable simple element" do
      context "and a repetition separator"
      context "and a component separator"
    end

    context "when the input has a non-repeatable composite element" do
      context "and one component"
      context "and many components"
      context "and too many components"
      context "and a component with a repetition separator"
    end

    context "when the input has no occurances of a repeatable simple element"
    context "when the input has one occurance of a repeatable simple element"
    context "when the input has many occurances of a repeatable simple element"
    context "when the input has too many occurances of a repeatable simple element"

    context "when the input has no occurances of a repeatable composite element"
    context "when the input has one occurance of a repeatable composite element"
    context "when the input has many occurances of a repeatable composite element"
    context "when the input has too many occurances of a repeatable composite element"
  end

end

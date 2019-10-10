describe Stupidedi::Reader::StreamReader do
  let(:success) { Stupidedi::Reader::Success }
  let(:stream)  { Stupidedi::Reader::StreamReader }

  def input(string)
    Stupidedi::Reader::Input.from_string(string)
  end

  describe "#stream?" do
    it "returns true"
  end

  describe "#empty?" do
    context "with no input available"
    context "with some input available"
  end

  describe "#read_character" do
    context "with no input available" do
      it "produces an error message"
      it "encodes the error position"
    end

    context "with only one input character available"
    context "with more than one input character available"
  end

  describe "#consume_character" do
    context "with no input available" do
      it "produces an error message"
      it "encodes the error position"
    end

    context "with only one input character available"
    context "with more than one input character available"
  end

  describe "#read_segment" do
    context "with no input available"
    context "with an isa segment at the start of input"
    context "with an isa segment after the start of input"
    context "with input that doesnt have an isa segment"
  end
end

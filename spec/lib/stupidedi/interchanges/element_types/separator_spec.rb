describe Stupidedi::Interchanges::ElementTypes::SeparatorVal do
  using Stupidedi::Refinements

  let(:element_use) do
    t = Stupidedi::Interchanges::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::Separator.new(:DE1, "String Element", 4, 10).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::NoPosition }

  def value(x)
    element_use.value(x, position)
  end

  describe ".empty" do
    it "returns #empty?" do
      expect(element_use.empty(position)).to be_empty
      expect(element_use.empty(position)).to be_separator
    end

    it "has a position" do
      expect(element_use.empty(position).position).to eql(position)
    end
  end

  describe ".value" do
    it "returns a value" do
      expect(element_use.value("~", position)).to eq("~")
    end

    it "has a position" do
      expect(element_use.value("~", position).position).to eql(position)
    end
  end

  context "#valid?" do
    todo "decide what values are not valid separators"
  end

  describe "#empty?" do
    context "when empty" do
      it "is true" do
        expect(value("")).to be_empty
        expect(value(" ")).to be_empty
        expect(value(nil)).to be_empty
      end
    end

    context "when not empty" do
      it "is false" do
        expect(value("~")).to_not be_empty
      end
    end
  end

  describe "#too_short?" do
    context "when too short" do
      it "is true" do
        expect(value("")).to be_too_short
      end
    end

    context "when not too short" do
      it "is false" do
        expect(value("  ")).to_not  be_too_short
        expect(value(" ")).to_not   be_too_short
      end
    end
  end

  describe "#too_long?" do
    context "when too long" do
      it "is true" do
        expect(value("   ")).to be_too_long
        expect(value("  ")).to  be_too_long
      end
    end

    context "when not too long" do
      it "is false" do
        expect(value(" ")).to_not be_too_long
        expect(value("")).to_not  be_too_long
      end
    end
  end

  describe "#separator?" do
    it "is true" do
      expect(value("")).to be_separator
    end
  end

  describe "#to_x12" do
    it "returns a String" do
      expect(value("").to_x12).to eq("")
      expect(value("~").to_x12).to eq("~")
    end
  end

  describe "#inspect" do
    it "returns a String" do
      expect(value("~").inspect).to be_a(String)
      expect(value("~").inspect).to match(/~/)
    end
  end
end

describe Stupidedi::Versions::Common::ElementTypes::StringVal do
  using Stupidedi::Refinements

  let(:element_use) do
    t = Stupidedi::Versions::FiftyTen::ElementTypes
    r = Stupidedi::Versions::FiftyTen::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::AN.new(:DE1, "String Element", 4, 10).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  def value(x)
    element_use.value(x, position)
  end

  todo ".from_date(format, value)"

  todo "::Invalid"

  context "::Empty" do
    let(:element_val) { value("") }

    describe "#string?" do
      specify { expect(element_val).to be_string }
    end

    describe "#position" do
      specify { expect(element_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(element_val).to be_empty }
    end

    describe "#valid?" do
      specify { expect(element_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(element_val).not_to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(element_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to    yield_with_args("") }
      specify { expect(element_val.map { "value" }).to eq("value") }
      specify { expect(element_val.map { "value" }).to eq("value") }
    end

    describe "#to_s" do
      specify { expect(element_val.to_s).to eql("") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(element_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(element_val.to_x12(false)).to eql("") }
      end
    end

    describe "#==(other)" do
      specify { expect(element_val).to eq("") }
      specify { expect(element_val).to eq(element_val) }
      specify { expect(element_val).to eq(element_use.value("", nil)) }
    end
  end

  context "::NonEmpty" do
    describe "#string?" do
      specify { expect(value("ABC")).to be_string }
    end

    describe "#position" do
      specify { expect(value("ABC").position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(value("ABC")).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(value("ABC")).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(value("ABC")).not_to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(value("A")).to               be_too_short }
      specify { expect(value("ABCD")).to_not        be_too_short }
      specify { expect(value("ABCDEFGHIJ")).to_not  be_too_short }
      specify { expect(value("ABCDEFGHIJK")).to_not be_too_short }
    end

    describe "#too_long?" do
      specify { expect(value("A")).to_not           be_too_long }
      specify { expect(value("ABCD")).to_not        be_too_long }
      specify { expect(value("ABCDEFGHIJ")).to_not  be_too_long }
      specify { expect(value("ABCDEFGHIJK")).to     be_too_long }
    end

    describe "#to_d" do
      specify { expect(value("1.3").to_d).to eq("1.3".to_d) }
    end

    describe "#to_f" do
      specify { expect(value("1.3").to_f).to eq("1.3".to_f) }
    end

    describe "#to_s" do
      specify { expect(value("abc").to_s).to    be_a(String) }
      specify { expect(value("abc").to_s).to    eq("abc")  }
      specify { expect(value(" abc ").to_s).to  eq(" abc") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(value("a").to_x12(true)).to    eq("a   ") }
        specify { expect(value(" a").to_x12(true)).to   eq(" a  ") }
        specify { expect(value("a"*10).to_x12(true)).to eq("a"*10) }
        specify { expect(value("a"*11).to_x12(true)).to eq("a"*10) }
      end

      context "without truncation" do
        specify { expect(value("a").to_x12(false)).to    eq("a   ") }
        specify { expect(value(" a").to_x12(false)).to   eq(" a  ") }
        specify { expect(value("a"*10).to_x12(false)).to eq("a"*10) }
        specify { expect(value("a"*11).to_x12(false)).to eq("a"*11) }
      end
    end

    describe "#length" do
      specify { expect(value("abc").length).to    eq(3) }
      specify { expect(value("abc ").length).to   eq(3) }
      specify { expect(value(" abc").length).to   eq(4) }
      specify { expect(value(" abc ").length).to  eq(4) }
    end

    describe "#=~" do
      specify { expect(value("abc")).to be =~ /b/ }
    end

    describe "#map(&block)" do
      specify { expect{|b| value("abc").map(&b) }.to  yield_with_args("abc") }
      specify { expect(value("abc").map(&:upcase)).to eq("ABC") }
      specify { expect(value("abc").map(&:upcase)).to be_string }
    end

    todo "#to_date(format)"

    describe "#==(other)" do
      specify { expect(value("ABC")).not_to eq("") }
      specify { expect(value("ABC")).not_to eq("ABC ") }
      specify { expect(value("ABC")).not_to eq(" ABC") }
      specify { expect(value("ABC")).not_to eq(" ABC ") }
      specify { expect(value("ABC")).to     eq("ABC") }
      specify { expect(value("ABC")).to     eq(value("ABC")) }
      specify { expect(value("ABC")).to     eq(element_use.value("ABC", nil)) }
      specify { expect(value("ABC ")).to    eq("ABC")   }
      specify { expect(value(" ABC")).to    eq(" ABC") }
      specify { expect(value(" ABC ")).to   eq(" ABC") }
    end
  end
end

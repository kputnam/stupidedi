describe Stupidedi::Versions::Common::ElementTypes::Nn do
  using Stupidedi::Refinements
  include Definitions

  let(:element_use) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::Nn.new(:DE1, "Numeric Element", 4, 6, 2).simple_use(r::Mandatory, d.bounded(1))
  end

  # Dummy file position
  let(:position) { Stupidedi::Reader::NoPosition }

  def value(x)
    element_use.value(x, position)
  end

  context "with an invalid precision" do
    it "raises an exception" do
      expect(lambda { element_use.definition.copy(:precision => 8) }).to \
        raise_error(Stupidedi::Exceptions::InvalidSchemaError)
    end
  end

  describe "::Invalid" do
    let(:invalid_val) { value("1A") }
    include_examples "global_element_types_invalid"

    describe "#numeric?" do
      specify { expect(invalid_val).to be_numeric }
    end

    describe "#to_d" do
      specify { expect(invalid_val).to_not respond_to(:to_d) }
    end

    describe "#to_f" do
      specify { expect(invalid_val).to_not respond_to(:to_f) }
    end

    describe "#to_i" do
      specify { expect(invalid_val).to_not respond_to(:to_i) }
    end

    describe "#to_r" do
      specify { expect(invalid_val).to_not respond_to(:to_r) }
    end
  end

  describe "::Empty" do
    let(:empty_val)   { value("") }
    let(:valid_str)   { "900" }
    let(:invalid_str) { "::" }
    include_examples "global_element_types_empty"

    describe "#numeric?" do
      specify { expect(empty_val).to be_numeric }
    end

    describe "#to_d" do
      specify { expect(empty_val).to_not respond_to(:to_d) }
    end

    describe "#to_f" do
      specify { expect(empty_val).to_not respond_to(:to_f) }
    end

    describe "#to_i" do
      specify { expect(empty_val).to_not respond_to(:to_i) }
    end

    describe "#to_r" do
      specify { expect(empty_val).to_not respond_to(:to_r) }
    end
  end

  context "::NonEmpty" do
    let(:element_val) { value("1234") }
    let(:inspect_str) { "12.34" }
    let(:valid_str)   { "987" }
    let(:invalid_str) { "wrong" }
    include_examples "global_element_types_non_empty"

    describe "#numeric?" do
      specify { expect(value("1234")).to be_numeric }
    end

    describe "#too_long?" do
      specify { expect(value("1234")).to_not be_too_long }
      specify { expect(value("12345678")).to be_too_long }
    end

    describe "#too_short?" do
      specify { expect(value("1234")).to_not be_too_short }
    end

    describe "#map(&block)" do
      specify { expect{|b| value("123").map(&b) }.to yield_with_args("1.23".to_d) }
      specify { expect(value("123").map{|x| "100" }).to eq("1.0".to_d) }
      specify { expect(value("123").map{|x| "A"}).to be_invalid }
      specify { expect(value("123").map{|x| nil}).to be_empty }
    end

    describe "#to_s" do
      specify { expect(value("1234").to_s).to eq("12.34") }
    end

    describe "#to_d" do
      specify { expect(value("1234").to_d).to eq("12.34".to_d) }
    end

    describe "#to_f" do
      specify { expect(value("1234").to_f).to eq("12.34".to_f) }
    end

    describe "#to_i" do
      specify { expect(value("1234").to_i).to eq("12.34".to_i) }
    end

    describe "#to_r" do
      specify { expect(value("1234").to_r).to eq("12.34".to_r) }
    end

    context "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(value("0").to_x12(true)).to eq("0000") }
        specify { expect(value("1").to_x12(true)).to eq("0001") }
        specify { expect(value("12").to_x12(true)).to eq("0012") }
        specify { expect(value("123").to_x12(true)).to eq("0123") }
        specify { expect(value("1234").to_x12(true)).to eq("1234") }
        specify { expect(value("12345").to_x12(true)).to eq("12345") }
        specify { expect(value("123456").to_x12(true)).to eq("123456") }
        specify { expect(value("1234567").to_x12(true)).to eq("123456") }
        specify { expect(value("12345678").to_x12(true)).to eq("123456") }
      end

      context "without truncation" do
        specify { expect(value("0").to_x12(false)).to eq("0000") }
        specify { expect(value("1").to_x12(false)).to eq("0001") }
        specify { expect(value("12").to_x12(false)).to eq("0012") }
        specify { expect(value("123").to_x12(false)).to eq("0123") }
        specify { expect(value("1234").to_x12(false)).to eq("1234") }
        specify { expect(value("12345").to_x12(false)).to eq("12345") }
        specify { expect(value("123456").to_x12(false)).to eq("123456") }
        specify { expect(value("1234567").to_x12(false)).to eq("1234567") }
        specify { expect(value("12345678").to_x12(false)).to eq("12345678") }
      end
    end

    describe "relational operators" do
      let(:a) { value("1234") }
      let(:b) { value("1235") }

      specify { expect("12.34".to_d).to eq(a) }
      specify { expect("12.35".to_d).to eq(b) }
      specify { expect(a).to            eq("12.34".to_d) }
      specify { expect(b).to            eq("12.35".to_d) }

      specify { expect(a.to_d).to be <  b.to_d }
      specify { expect(a.to_d).to be <  b }
      specify { expect(a).to      be <  b.to_d }
      specify { expect(a).to      be <  b }

      specify { expect(a.to_d).to be <= b.to_d }
      specify { expect(a.to_d).to be <= b }
      specify { expect(a).to      be <= b.to_d }
      specify { expect(a).to      be <= b }

      specify { expect(b.to_d).to be >  a.to_d }
      specify { expect(b.to_d).to be >  a }
      specify { expect(b).to      be >  a.to_d }
      specify { expect(b).to      be >  a }

      specify { expect(b.to_d).to be >= a.to_d }
      specify { expect(b.to_d).to be >= a }
      specify { expect(b).to      be >= a.to_d }
      specify { expect(b).to      be >= a }

      specify { expect(a.to_d).to be <= a.to_d }
      specify { expect(a.to_d).to be <= a }
      specify { expect(a).to      be <= a.to_d }
      specify { expect(a).to      be <= a }

      specify { expect(b.to_d).to eq(b.to_d) }
      specify { expect(b.to_d).to eq(b) }
      specify { expect(b).to      eq(b.to_d) }
      specify { expect(b).to      eq(b) }

      specify { expect(a.to_d).to be <= a.to_d }
      specify { expect(a.to_d).to be <= a }
      specify { expect(a).to      be <= a.to_d }
      specify { expect(a).to      be <= a }

      specify { expect(a.to_d).to be >= a.to_d }
      specify { expect(a.to_d).to be >= a }
      specify { expect(a).to      be >= a.to_d }
      specify { expect(a).to      be >= a }

      specify { expect(b.to_d).to be <= b.to_d }
      specify { expect(b.to_d).to be <= b }
      specify { expect(b).to      be <= b.to_d }
      specify { expect(b).to      be <= b }

      specify { expect(b.to_d).to be >= b.to_d }
      specify { expect(b.to_d).to be >= b }
      specify { expect(b).to      be >= b.to_d }
      specify { expect(b).to      be >= b }

      specify { expect(a.to_d).not_to eq(b.to_d) }
      specify { expect(a.to_d).not_to eq(b) }
      specify { expect(a).not_to      eq(b.to_d) }
      specify { expect(a).not_to      eq(b) }

      specify { expect(b.to_d).not_to eq(a.to_d) }
      specify { expect(b.to_d).not_to eq(a) }
      specify { expect(b).not_to      eq(a.to_d) }
      specify { expect(b).not_to      eq(a) }
    end

    describe "arithmetic operators" do
      let(:a) { value("1050") } # 10.50
      let(:b) { value("0200") } #  2.00

      specify { expect(a.to_d / b.to_d).to  eq("5.25".to_d) }
      specify { expect(a / b.to_d).to       eq("5.25".to_d) }
      specify { expect(a.to_d / b).to       eq("5.25".to_d) }
      specify { expect(a / b).to            eq("5.25".to_d) }

      specify { expect(a.to_d * b.to_d).to  eq("21.0".to_d) }
      specify { expect(a * b.to_d).to       eq("21.0".to_d) }
      specify { expect(a.to_d * b).to       eq("21.0".to_d) }
      specify { expect(a * b).to            eq("21.0".to_d) }

      specify { expect(a.to_d + b.to_d).to  eq("12.5".to_d) }
      specify { expect(a + b.to_d).to       eq("12.5".to_d) }
      specify { expect(a.to_d + b).to       eq("12.5".to_d) }
      specify { expect(a + b).to            eq("12.5".to_d) }

      specify { expect(a.to_d - b.to_d).to  eq("8.5".to_d) }
      specify { expect(a - b.to_d).to       eq("8.5".to_d) }
      specify { expect(a - b).to            eq("8.5".to_d) }
      specify { expect(a.to_d - b).to       eq("8.5".to_d) }
      specify { expect(a.to_d - b).to       eq("8.5".to_d) }

      specify { expect(a.to_d % b.to_d).to  eq("0.5".to_d) }
      specify { expect(a % b.to_d).to       eq("0.5".to_d) }
      specify { expect(a.to_d % b).to       eq("0.5".to_d) }
      specify { expect(a % b).to            eq("0.5".to_d) }

      specify { expect(-a).to               eq("-10.50".to_d) }
      specify { expect((-a).abs).to         eq(a) }
      specify { expect(+a).to               eq(a) }
    end
  end
end

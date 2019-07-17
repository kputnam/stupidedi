describe Stupidedi::Versions::Common::ElementTypes::R do
  using Stupidedi::Refinements
  include Definitions

  let(:element_use) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::R.new(:DE1, "Numeric Element", 4, 6, 2).simple_use(r::Mandatory, d.bounded(1))
  end

  # Dummy file position
  let(:position) { Stupidedi::Reader::NoPosition }

  def value(x)
    element_use.value(x, position)
  end

  context "with an invalid max_precision" do
    it "raises an exception" do
      expect(lambda { element_use.definition.copy(:max_precision => 8) }).to \
        raise_error(Stupidedi::Exceptions::InvalidSchemaError)
    end
  end

  context "::Invalid" do
    let(:invalid_val) { value("1A") }
    include_examples "global_element_types_invalid"

    describe "#numeric?" do
      specify { expect(invalid_val).to be_numeric }
    end

    context "#to_d" do
      specify { expect(invalid_val).to_not respond_to(:to_d) }
    end

    context "#to_f" do
      specify { expect(invalid_val).to_not respond_to(:to_f) }
    end

    context "#to_i" do
      specify { expect(invalid_val).to_not respond_to(:to_i) }
    end

    context "#to_r" do
      specify { expect(invalid_val).to_not respond_to(:to_r) }
    end
  end

  context "::Empty" do
    let(:empty_val)   { value("") }
    let(:valid_str)   { "1.23" }
    let(:invalid_str) { "ABC" }
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

  context "NonEmpty" do
    let(:element_val) { value("1.23") }
    let(:valid_str)   { "999" }
    let(:invalid_str) { "ABC" }
    include_examples "global_element_types_non_empty"

    describe "#too_long?" do
      specify { expect(element_val).not_to be_too_long }
      specify { expect(value("12345678")).to be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to yield_with_args("1.23".to_d) }
      specify { expect{|b| value("1.23456".to_d).map(&b) }.to yield_with_args("1.23456".to_d) }
    end

    describe "#to_s" do
      context "with max_precision" do
        specify { expect(element_val.to_s).to eq("1.23") }
      end

      context "without max_precision" do
        let(:element_use_) do
          element_use.copy(
            :definition => element_use.definition.copy(
              :max_precision => nil))
        end

        specify { expect(element_use_.value("1.23123", position).to_s).to eq("1.23123") }
      end
    end

    describe "#to_d" do
      specify { expect(value("0").to_d).to    eq("0".to_d) }
      specify { expect(value("0.25").to_d).to eq("0.25".to_d) }
      specify { expect(value("13.1").to_d).to eq("13.1".to_d) }
      specify { expect(value("-1.9").to_d).to eq("-1.9".to_d) }
    end

    describe "#to_f" do
      specify { expect(value("0").to_f).to    eq(0) }
      specify { expect(value("0.25").to_f).to eq(0.25) }
      specify { expect(value("13.1").to_f).to eq(13.1) }
      specify { expect(value("-1.9").to_f).to eq(-1.9) }
    end

    describe "#to_i" do
      specify { expect(value("0").to_i).to    eq(0) }
      specify { expect(value("0.25").to_i).to eq(0) }
      specify { expect(value("13.1").to_i).to eq(13) }
      specify { expect(value("-1.9").to_i).to eq(-1) }
    end

    describe "#to_r" do
      specify { expect(value("13.25").to_r).to eq("13.25".to_r) }
    end

    describe "#to_x12(truncate)" do
      # Remember the element definition has length 4-6, with precision 2

      context "with truncation" do
        specify { expect(value("0").to_x12).to        eq("0000") }
        specify { expect(value("1").to_x12).to        eq("0001") }
        specify { expect(value("20").to_x12).to       eq("0020") }
        specify { expect(value("300").to_x12).to      eq("0300") }
        specify { expect(value("4000").to_x12).to     eq("4000") }
        specify { expect(value("50000").to_x12).to    eq("50000") }
        specify { expect(value("600000").to_x12).to   eq("600000") }
        specify { expect(value("7000000").to_x12).to  eq("700000") }

        specify { expect(value("-0").to_x12).to        eq("0000") }
        specify { expect(value("-1").to_x12).to        eq("-0001") }
        specify { expect(value("-20").to_x12).to       eq("-0020") }
        specify { expect(value("-300").to_x12).to      eq("-0300") }
        specify { expect(value("-4000").to_x12).to     eq("-4000") }
        specify { expect(value("-50000").to_x12).to    eq("-50000") }
        specify { expect(value("-600000").to_x12).to   eq("-600000") }
        specify { expect(value("-7000000").to_x12).to  eq("-700000") }

        specify { expect(value("0.0").to_x12).to        eq("0000") }
        specify { expect(value("0.1").to_x12).to        eq("00.1") }
        specify { expect(value("0.02").to_x12).to       eq("0.02") }
        specify { expect(value("0.003").to_x12).to      eq("0000") } # precision is only 2

        specify { expect(value("-15.0").to_x12).to        eq("-0015") }
        specify { expect(value("-15.1").to_x12).to        eq("-15.1") }
        specify { expect(value("-15.02").to_x12).to       eq("-15.02") }
        specify { expect(value("-15.003").to_x12).to      eq("-0015") }
      end

      context "without truncation" do
        specify { expect(value("0").to_x12(false)).to        eq("0000") }
        specify { expect(value("1").to_x12(false)).to        eq("0001") }
        specify { expect(value("20").to_x12(false)).to       eq("0020") }
        specify { expect(value("300").to_x12(false)).to      eq("0300") }
        specify { expect(value("4000").to_x12(false)).to     eq("4000") }
        specify { expect(value("50000").to_x12(false)).to    eq("50000") }
        specify { expect(value("600000").to_x12(false)).to   eq("600000") }
        specify { expect(value("7000000").to_x12(false)).to  eq("7000000") }

        specify { expect(value("-0").to_x12(false)).to        eq("0000") }
        specify { expect(value("-1").to_x12(false)).to        eq("-0001") }
        specify { expect(value("-20").to_x12(false)).to       eq("-0020") }
        specify { expect(value("-300").to_x12(false)).to      eq("-0300") }
        specify { expect(value("-4000").to_x12(false)).to     eq("-4000") }
        specify { expect(value("-50000").to_x12(false)).to    eq("-50000") }
        specify { expect(value("-600000").to_x12(false)).to   eq("-600000") }
        specify { expect(value("-7000000").to_x12(false)).to  eq("-7000000") }

        specify { expect(value("0.0").to_x12(false)).to        eq("0000") }
        specify { expect(value("0.1").to_x12(false)).to        eq("00.1") }
        specify { expect(value("0.02").to_x12(false)).to       eq("0.02") }
        specify { expect(value("0.003").to_x12(false)).to      eq("0000") } # precision is only 2

        specify { expect(value("-15.0").to_x12(false)).to        eq("-0015") }
        specify { expect(value("-15.1").to_x12(false)).to        eq("-15.1") }
        specify { expect(value("-15.02").to_x12(false)).to       eq("-15.02") }
        specify { expect(value("-15.003").to_x12(false)).to      eq("-0015") }
      end
    end

    describe "relational operators" do
      let(:a) { value("123.4") }
      let(:b) { value("123.5") }

      specify { expect(a).to      eq("123.4".to_d) }
      specify { expect(b).to      eq("123.5".to_d) }

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
      let(:a) { value("10.50") }
      let(:b) { value("2") }

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

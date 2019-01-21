describe Stupidedi::Versions::Common::ElementTypes::R do
  using Stupidedi::Refinements

  let(:element_use) do
    t = Stupidedi::Versions::FiftyTen::ElementTypes
    r = Stupidedi::Versions::FiftyTen::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::R.new(:DE1, "Numeric Element", 4, 6, 2).simple_use(r::Mandatory, d.bounded(1))
  end

  # Dummy file position
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  def value(x)
    element_use.value(x, position)
  end


  context "Invalid" do
    let(:element_val_a) { value("1A") }
    let(:element_val_b) { value("A1") }

    describe "#position" do
      specify { expect(element_val_a.position).to eql(position) }
      specify { expect(element_val_b.position).to eql(position) }
    end

    describe "#numeric?" do
      specify { expect(element_val_a).to be_numeric }
      specify { expect(element_val_b).to be_numeric }
    end

    describe "#empty?" do
      specify { expect(element_val_a).not_to be_empty }
      specify { expect(element_val_b).not_to be_empty }
    end

    describe "#valid?" do
      specify { expect(element_val_a).not_to be_valid }
      specify { expect(element_val_b).not_to be_valid }
    end

    describe "#invalid?" do
      specify { expect(element_val_a).to be_invalid }
      specify { expect(element_val_b).to be_invalid }
    end

    todo "#too_long?"
    todo "#too_short?"
    todo "#map(&block)"
    todo "#to_s"
    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"
    todo "#to_x12(truncate)"
    todo "#==(other)"
  end

  context "Empty" do
    let(:element_val) { value("") }

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
      specify { expect(element_val).to_not be_invalid }
    end

    describe "#too_short?" do
      specify { expect(element_val).not_to be_too_short }
    end

    describe "#too_long?" do
      specify { expect(element_val).not_to be_too_long }
    end

    describe "#map(&block)" do
      specify { expect(element_val.map { "1.23" }).to eq("1.23") }
      specify { expect(element_val.map { "1.23" }).to be_numeric }
    end

    describe "#to_s" do
      specify { expect(element_val.to_s).to eq("") }
    end

    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(element_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(element_val.to_x12(false)).to eql("") }
      end
    end

    describe "#==(other)" do
      specify { expect(element_val).to eq(element_val) }
      specify { expect(element_val).to eq(nil) }
      specify { expect(element_val).to eq(value("")) }
    end
  end

  context "NonEmpty" do
    let(:element_val) { value("1.23") }

    describe "#position" do
      specify { expect(element_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(element_val).to_not be_empty }
    end

    describe "#valid?" do
      specify { expect(element_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(element_val).to_not be_invalid }
    end

    describe "#too_short?" do
      specify { expect(element_val).not_to be_too_short }
    end

    describe "#too_long?" do
      specify { expect(element_val).not_to be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to yield_with_args("1.23".to_d) }
    end

    describe "#to_s" do
      specify { expect(element_val.to_s).to eq("1.23") }
    end

    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"

    describe "#to_x12(truncate)" do
      todo "with truncation"
      todo "without truncation"
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

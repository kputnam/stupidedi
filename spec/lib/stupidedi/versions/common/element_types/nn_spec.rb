fdescribe Stupidedi::Versions::Common::ElementTypes::Nn do
  using Stupidedi::Refinements
  include Definitions

  let(:element_use) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::Nn.new(:DE1, "Numeric Element", 4, 6, 2).simple_use(r::Mandatory, d.bounded(1))
  end

  # Dummy file position
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

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
    let(:invalid_val_a) { value("1A") }
    let(:invalid_val_b) { value("A1") }

    describe "#numeric?" do
      specify { expect(invalid_val_a).to be_numeric }
      specify { expect(invalid_val_b).to be_numeric }
    end

    describe "#position" do
      specify { expect(invalid_val_a.position).to eql(position) }
      specify { expect(invalid_val_b.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(invalid_val_a).not_to be_empty }
      specify { expect(invalid_val_b).not_to be_empty }
    end

    describe "#valid?" do
      specify { expect(invalid_val_a).not_to be_valid }
      specify { expect(invalid_val_b).not_to be_valid }
    end

    describe "#invalid?" do
      specify { expect(invalid_val_a).to be_invalid }
      specify { expect(invalid_val_b).to be_invalid }
    end

    todo "#too_long?"
    todo "#too_short?"

    describe "#map(&block)" do
      specify { expect{|b| invalid_val_a.map(&b) }.to yield_with_args(nil) }
      specify { expect(invalid_val_a.map{|x| "1"}).to eq(value("1")) }
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(invalid_val.inspect).to be_a(String)
        end

        it "indicates invalid" do
          expect(invalid_val.inspect).to match(/invalid/)
        end
      end

      context "when forbidden" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_not_used).value("A1", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_mandatory).value("A1", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_optional).value("A1", position)
        end

        include_examples "inspect"
      end
    end

    describe "#to_s" do
      specify { expect(invalid_val_a.to_s).to eq("") }
    end

    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"

    context "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(invalid_val_a.to_x12(true)).to eq("") }
      end

      context "without truncation" do
        specify { expect(invalid_val_a.to_x12(false)).to eq("") }
      end
    end

    describe "#==(other)" do
      specify { expect(invalid_val_a).to     eq(invalid_val_a) }
      specify { expect(invalid_val_a).to_not eq(invalid_val_b) }
    end

    describe "#copy(changes)" do
      specify { expect(invalid_val_a.copy).to eql(invalid_val_a) }
    end
  end

  describe "::Empty" do
    let(:empty_val) { value("") }

    describe "#numeric?" do
      specify { expect(empty_val).to be_numeric }
    end

    describe "#position" do
      specify { expect(empty_val.position).to eql(position) }
    end

    describe "#empty?" do
      specify { expect(empty_val).to be_empty }
    end

    describe "#valid?" do
      specify { expect(empty_val).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(empty_val).to_not be_invalid }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_long }
    end

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(empty_val.inspect).to be_a(String)
        end

        it "indicates empty" do
          expect(empty_val.inspect).to match(/empty/)
        end
      end

      context "when forbidden" do
        let(:empty_val) do
          element_use.copy(:requirement => e_not_used).empty(position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:empty_val) do
          element_use.copy(:requirement => e_mandatory).empty(position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:empty_val) do
          element_use.copy(:requirement => e_optional).empty(position)
        end

        include_examples "inspect"
      end
    end

    describe "#map(&block)" do
      specify { expect{|b| empty_val.map(&b) }.to  yield_with_args(nil) }
      specify { expect(empty_val.map { "123" }).to eq("1.23") }
      specify { expect(empty_val.map { "123" }).to be_numeric }
    end

    describe "#to_s" do
      specify { expect(empty_val.to_s).to eql("") }
    end

    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(empty_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(empty_val.to_x12(false)).to eql("") }
      end
    end

    describe "#==(other)" do
      specify { expect(empty_val).to eq(empty_val) }
      specify { expect(empty_val).to eq(nil) }
      specify { expect(empty_val).to eq(value("")) }
    end

    describe "#copy(changes)" do
      specify { expect(empty_val.copy).to eq(empty_val) }
      specify { expect(empty_val.copy(:value => "1234")).to eq("12.34") }
      specify { expect(empty_val.copy(:value => "1234").position).to eql(position) }
    end
  end

  context "::NonEmpty" do
    describe "#numeric?" do
      specify { expect(value("1234")).to be_numeric }
    end

    describe "#position" do
      specify { expect(value("1234").position).to eql(position) }
    end

    describe "#valid?" do
      specify { expect(value("1234")).to be_valid }
    end

    describe "#invalid?" do
      specify { expect(value("1234")).to_not be_invalid }
    end

    describe "#empty?" do
      specify { expect(value("1234")).to_not be_empty }
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
      specify { expect(value("123").map{|x| "100" }).to eq("1.0") }
      specify { expect(value("123").map{|x| "A"}).to be_invalid }
      specify { expect(value("123").map{|x| nil}).to be_empty }
    end

    todo "#to_s"
    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"

    context "#to_x12(truncate)" do
      todo "with truncation"
      todo "without truncation"
    end

    todo "#==(other)"

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(element_val.inspect).to be_a(String)
        end

        it "indicates valid" do
          expect(element_val.inspect).to match(/value/)
        end

        it "indicates value" do
          expect(element_val.inspect).to match(/#{element_val.to_s}/)
        end
      end

      context "when forbidden" do
        let(:element_val) do
          element_use.copy(:requirement => e_not_used).value("100", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:element_val) do
          element_use.copy(:requirement => e_mandatory).value("100", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:element_val) do
          element_use.copy(:requirement => e_optional).value("100", position)
        end

        include_examples "inspect"
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

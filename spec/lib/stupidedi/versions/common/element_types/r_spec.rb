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
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

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
    let(:invalid_val_a) { value("1A") }
    let(:invalid_val_b) { value("A1") }

    describe "#position" do
      specify { expect(invalid_val_a.position).to eql(position) }
      specify { expect(invalid_val_b.position).to eql(position) }
    end

    describe "#numeric?" do
      specify { expect(invalid_val_a).to be_numeric }
      specify { expect(invalid_val_b).to be_numeric }
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

    describe "#too_long?" do
      specify { expect(invalid_val_a).to_not be_too_long }
    end

    describe "#too_short?" do
      specify { expect(invalid_val_a).to_not be_too_short }
    end

    describe "#map(&block)" do
      specify { expect{|b| invalid_val_a.map(&b) }.to yield_with_args(nil) }
      specify { expect(invalid_val_a.map{|x| "1"}).to eq(value("1")) }
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

  context "::Empty" do
    let(:empty_val) { value("") }

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
      specify { expect(empty_val).not_to be_too_short }
    end

    describe "#too_long?" do
      specify { expect(empty_val).not_to be_too_long }
    end

    describe "#map(&block)" do
      specify { expect(empty_val.map { "1.23" }).to eq("1.23") }
      specify { expect(empty_val.map { "1.23" }).to be_numeric }
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

    describe "#to_s" do
      specify { expect(empty_val.to_s).to eq("") }
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
      specify { expect(empty_val.copy(:value => "1.0")).to eq(value("1.0")) }
      specify { expect(empty_val.copy(:value => "1.0").position).to eql(position) }
    end
  end

  context "NonEmpty" do
    let(:element_val) { value("1.23123") }

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
      specify { expect(value("12345678")).to be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| element_val.map(&b) }.to yield_with_args("1.23123".to_d) }
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
          element_use.copy(:requirement => e_not_used).value("1.00", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:element_val) do
          element_use.copy(:requirement => e_mandatory).value("1.00", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:element_val) do
          element_use.copy(:requirement => e_optional).value("1.00", position)
        end

        include_examples "inspect"
      end
    end

    todo "#to_d"
    todo "#to_f"
    todo "#to_i"
    todo "#to_r"

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

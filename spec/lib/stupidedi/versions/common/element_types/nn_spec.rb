using Stupidedi::Refinements

describe "Stupidedi::Versions::Common::ElementTypes::Nn" do
  let(:types) { Stupidedi::Versions::FiftyTen::ElementTypes }
  let(:r)     { Stupidedi::Versions::FiftyTen::ElementReqs }
  let(:d)     { Stupidedi::Schema::RepeatCount }

  # Dummy element definition E1: min/max length 4/6, two decimal places
  let(:eldef) { types::Nn.new(:E1, "Numeric Element", 4, 6, 2) }
  let(:eluse) { eldef.simple_use(r::Mandatory, d.bounded(1)) }

  # Dummy file position
  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

  describe "Invalid" do
    let(:el) { eluse.value("1A", position) }
    let(:em) { eluse.value("A1", position) }

    describe "#position" do
      specify { expect(el.position).to be == position }
      specify { expect(em.position).to be == position }
    end

    describe "#empty?" do
      specify { expect(el).not_to be_empty }
      specify { expect(em).not_to be_empty }
    end

    describe "#valid?" do
      specify { expect(el).not_to be_valid }
      specify { expect(em).not_to be_valid }
    end

    describe "#too_short?"
    describe "#map"
    describe "#to_s"
    describe "#to_x12"
    describe "#=="
  end

  describe "Empty" do
    let(:el) { eluse.value("", position) }

    describe "#position" do
      specify { expect(el.position).to be == position }
    end

    describe "#empty?" do
      specify { expect(el).to be_empty }
    end

    describe "#valid?" do
      specify { expect(el).to be_valid }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(el).to_not be_too_long }
    end

    describe "#map" do
      specify { expect(el.map { "123" }).to be == "1.23" }
      specify { expect(el.map { "123" }).to be_numeric }
    end

    describe "#to_s" do
      specify { expect(el.to_s).to be == "" }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(el.to_x12(true)).to be == "" }
        specify { expect(el.to_x12(true)).to be_a(String) }
      end

      context "without truncation" do
        specify { expect(el.to_x12(false)).to be == "" }
        specify { expect(el.to_x12(false)).to be_a(String) }
      end
    end

    describe "#==" do
      specify { expect(el).to be == el }
      specify { expect(el).to be == nil }
      specify { expect(el).to be == eluse.value("", position) }
    end
  end

  context "NonEmpty" do
    describe "relational operators" do
      let(:a) { eluse.value("1234", position) }
      let(:b) { eluse.value("1235", position) }

      specify { expect("12.34".to_d).to be == a }
      specify { expect("12.35".to_d).to be == b }
      specify { expect(a).to            be == "12.34".to_d }
      specify { expect(b).to            be == "12.35".to_d }

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

      specify { expect(b.to_d).to be == b.to_d }
      specify { expect(b.to_d).to be == b }
      specify { expect(b).to      be == b.to_d }
      specify { expect(b).to      be == b }

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

      specify { expect(a.to_d).not_to be == b.to_d }
      specify { expect(a.to_d).not_to be == b }
      specify { expect(a).not_to      be == b.to_d }
      specify { expect(a).not_to      be == b }

      specify { expect(b.to_d).not_to be == a.to_d }
      specify { expect(b.to_d).not_to be == a }
      specify { expect(b).not_to      be == a.to_d }
      specify { expect(b).not_to      be == a }
    end

    describe "arithmetic operators" do
      let(:a) { eluse.value("1050", position) } # 10.50
      let(:b) { eluse.value("0200", position) } #  2.00

      specify { expect(a.to_d / b.to_d).to  be == "5.25".to_d }
      specify { expect(a / b.to_d).to       be == "5.25".to_d }
      specify { expect(a.to_d / b).to       be == "5.25".to_d }
      specify { expect(a / b).to            be == "5.25".to_d }

      specify { expect(a.to_d * b.to_d).to  be == "21.0".to_d }
      specify { expect(a * b.to_d).to       be == "21.0".to_d }
      specify { expect(a.to_d * b).to       be == "21.0".to_d }
      specify { expect(a * b).to            be == "21.0".to_d }

      specify { expect(a.to_d + b.to_d).to  be == "12.5".to_d }
      specify { expect(a + b.to_d).to       be == "12.5".to_d }
      specify { expect(a.to_d + b).to       be == "12.5".to_d }
      specify { expect(a + b).to            be == "12.5".to_d }

      specify { expect(a.to_d - b.to_d).to  be == "8.5".to_d }
      specify { expect(a - b.to_d).to       be == "8.5".to_d }
      specify { expect(a - b).to            be == "8.5".to_d }
      specify { expect(a.to_d - b).to       be == "8.5".to_d }
      specify { expect(a.to_d - b).to       be == "8.5".to_d }

      specify { expect(a.to_d % b.to_d).to  be == "0.5".to_d }
      specify { expect(a % b.to_d).to       be == "0.5".to_d }
      specify { expect(a.to_d % b).to       be == "0.5".to_d }
      specify { expect(a % b).to            be == "0.5".to_d }

      specify { expect(-a).to               be == "-10.50".to_d }
      specify { expect((-a).abs).to         be == a }
      specify { expect(+a).to               be == a }
    end
  end
end

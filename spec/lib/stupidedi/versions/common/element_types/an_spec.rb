describe Stupidedi::Versions::Common::ElementTypes::AN do
  using Stupidedi::Refinements
  include Definitions
  include TimeStringMatchers

  let(:element_use) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::AN.new(:DE1, "String Element", 4, 10).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Position::NoPosition }

  let(:invalid_str) do
    "i'm angry!!".tap do |invalid|
      class << invalid
        def to_s
          raise "grr"
        end
      end
    end
  end

  def value(x)
    element_use.value(x, position)
  end

  describe ".value" do
    context "when given a Date" do
      specify { expect(value(Date.today)).to be_invalid }
    end

    context "when given a Time" do
      specify { expect(value(Time.now)).to be_invalid }
    end
  end

  context "::Invalid" do
    let(:invalid_val) { value(invalid_str) }
    include_examples "global_element_types_invalid"

    describe "#string?" do
      specify { expect(invalid_val).to be_string }
    end
  end

  context "::Empty" do
    let(:empty_val) { value("") }
    let(:valid_str) { "TEA TIME" }
    include_examples "global_element_types_empty"

    describe "#string?" do
      specify { expect(empty_val).to be_string }
    end
  end

  context "::NonEmpty" do
    let(:element_val) { value("ABC XYZ") }
    let(:valid_str)   { "TEA TIME" }
    include_examples "global_element_types_non_empty"

    describe "#string?" do
      specify { expect(element_val).to be_string }
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

    describe "#to_date(format) and .strptime(format, value)" do
      let(:an) { Stupidedi::Versions::Common::ElementTypes::AN }

      context "when wrong type is given" do
        specify { expect(lambda { an.strftime("D8", "20181231") }).to  raise_error(TypeError) }
        specify { expect(lambda { an.strftime("RD8", "20181231") }).to raise_error(TypeError) }
        specify { expect(lambda { an.strptime("RD8", "20181231") }).to raise_error(TypeError) }
      end

      context "when wrong format specifier is given" do
        specify { expect(lambda { an.strftime("XX", "20181231") }).to   raise_error(/format specifier/) }
        specify { expect(lambda { an.strptime("XX", Time.now.utc) }).to raise_error(/format specifier/) }
      end

      context "when format is range (x-y)" do
        specify { expect(value("20181231-20190130").to_date("RD8")).to eq(Time.utc(2018, 12, 31)..Time.utc(2019, 1, 30)) }

        specify "strftime(format, strptime(format, strftime(format, x))) == strftime(format, x)" do
          an::DATE_FORMAT_RANGE.keys.each do |format|
            expect(format).to roundtrip(Time.now.utc..Time.now.utc + 60*60*36)
          end
        end
      end

      context "when format is single" do
        specify { expect(value("20190130").to_date("D8")).to eq(Time.utc(2019, 1, 30)) }

        specify "strftime(format, strptime(format, strftime(format, x))) == strftime(format, x)" do
          an::DATE_FORMAT_SINGLE.keys.each do |format|
            next if format == "CC"
            expect(format).to roundtrip(Time.now.utc)
          end
        end
      end
    end

    describe "#==(other)" do
      specify { expect(value("ABC")).to_not eq("") }
      specify { expect(value("ABC")).to     eq("ABC ") }
      specify { expect(value("ABC")).to_not eq(" ABC") }
      specify { expect(value("ABC")).to_not eq(" ABC ") }
      specify { expect(value("ABC")).to     eq("ABC") }
      specify { expect(value("ABC")).to     eq(value("ABC")) }
      specify { expect(value("ABC")).to     eq(element_use.value("ABC", nil)) }
      specify { expect(value("ABC ")).to    eq("ABC")   }
      specify { expect(value(" ABC")).to    eq(" ABC") }
      specify { expect(value(" ABC ")).to   eq(" ABC") }
    end

    describe "#coerce(other)" do
      specify { expect("ABC" + value("abc")).to eq("ABCabc") }
      specify { expect(value("ABC") + "abc").to eq("ABCabc") }
    end
  end
end

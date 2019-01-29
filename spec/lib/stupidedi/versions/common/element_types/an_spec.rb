describe Stupidedi::Versions::Common::ElementTypes::StringVal do
  using Stupidedi::Refinements
  include Definitions
  include TimeStringMatchers

  let(:element_use) do
    t = Stupidedi::Versions::Common::ElementTypes
    r = Stupidedi::Versions::Common::ElementReqs
    d = Stupidedi::Schema::RepeatCount
    t::AN.new(:DE1, "String Element", 4, 10).simple_use(r::Mandatory, d.bounded(1))
  end

  let(:position) { Stupidedi::Reader::Position.new(100, 4, 19, "test.x12") }

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
    let(:invalid) do
      "i'm angry!!".tap do |invalid|
        class << invalid
          def to_s
            raise "grr"
          end
        end
      end
    end

    let(:invalid_val) do
      value(invalid)
    end

    describe "#id?" do
      specify { expect(invalid_val).to be_string }
    end

    describe "#position" do
      specify { expect(invalid_val.position).to eql(position) }
    end

    describe "#valid?" do
      specify { expect(invalid_val).to_not be_valid }
    end

    describe "#invalid?" do
      specify { expect(invalid_val).to be_invalid }
    end

    describe "#empty?" do
      specify { expect(invalid_val).to_not be_empty }
    end

    describe "#too_short?" do
      specify { expect(invalid_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(invalid_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| invalid_val.map(&b) }.to yield_with_args(nil) }
      specify { expect(invalid_val.map { "xx" }).to eq(value("xx"))      }
      specify { expect(invalid_val.map { nil }).to  eq(value(""))        }
    end

    describe "#to_s" do
      specify { expect(invalid_val.to_s).to eq("") }
    end

    describe "#to_x12" do
      context "with truncation" do
        specify { expect(invalid_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(invalid_val.to_x12(false)).to eql("") }
      end
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
          element_use.copy(:requirement => e_not_used).value(invalid, position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_mandatory).value(invalid, position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:invalid_val) do
          element_use.copy(:requirement => e_optional).value(invalid, position)
        end

        include_examples "inspect"
      end
    end

    describe "#==(other)" do
      specify { expect(invalid_val).to     eq(invalid_val) }
      specify { expect(invalid_val).to_not eq(value("")) }
      specify { expect(invalid_val).to_not eq("") }
    end

    describe "#copy(changes)" do
      specify { expect(invalid_val.copy).to eql(invalid_val) }
    end
  end

  context "::Empty" do
    let(:empty_val) { value("") }

    describe "#string?" do
      specify { expect(empty_val).to be_string }
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
      specify { expect(empty_val).not_to be_invalid }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_short }
    end

    describe "#too_short?" do
      specify { expect(empty_val).to_not be_too_long }
    end

    describe "#map(&block)" do
      specify { expect{|b| empty_val.map(&b) }.to    yield_with_args(nil) }
      specify { expect(empty_val.map { "value" }).to eq("value") }
      specify { expect(empty_val.map { "value" }).to eq("value") }
    end

    describe "#to_s" do
      specify { expect(empty_val.to_s).to eql("") }
    end

    describe "#to_x12(truncate)" do
      context "with truncation" do
        specify { expect(empty_val.to_x12(true)).to eql("") }
      end

      context "without truncation" do
        specify { expect(empty_val.to_x12(false)).to eql("") }
      end
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

    describe "#==(other)" do
      specify { expect(empty_val).to eq("") }
      specify { expect(empty_val).to eq(empty_val) }
      specify { expect(empty_val).to eq(element_use.value("", nil)) }
    end

    describe "#coerce(other)" do
      specify { expect("" + empty_val).to eq("") }
      specify { expect(empty_val + "").to eq("") }
    end

    describe "#copy(changes)" do
      specify { expect(empty_val.copy).to eql(empty_val) }
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

    describe "#inspect" do
      shared_examples "inspect" do
        it "returns a String" do
          expect(element_val.inspect).to be_a(String)
        end

        it "indicates valid" do
          expect(element_val.inspect).to match(/value/)
        end

        it "indicates value" do
          expect(element_val.inspect).to match(/#{element_val.value}/)
        end
      end

      context "when forbidden" do
        let(:element_val) do
          element_use.copy(:requirement => e_not_used).value("abc", position)
        end

        include_examples "inspect"
      end

      context "when required" do
        let(:element_val) do
          element_use.copy(:requirement => e_mandatory).value("abc", position)
        end

        include_examples "inspect"
      end

      context "when optional" do
        let(:element_val) do
          element_use.copy(:requirement => e_optional).value("abc", position)
        end

        include_examples "inspect"
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

    describe "#coerce(other)" do
      specify { expect("ABC" + value("abc")).to eq("ABCabc") }
      specify { expect(value("ABC") + "abc").to eq("ABCabc") }
    end

    describe "#copy(changes)" do
      specify { expect(value("abc").copy(:value => "")).to be_empty }
      specify { expect(value("abc").copy(:value => "").position).to eql(position) }
    end
  end
end
